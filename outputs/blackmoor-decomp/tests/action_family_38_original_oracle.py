#!/usr/bin/env python3
"""A-38.1 original-x86 loader/constructor oracle. Allocation is the only hook.

Run with work/tools/oracle-python/bin/python. Resources and evidence stay local.
Default reports use a newly created private directory; --result must not exist.
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
from test_action_family_38 import (Decoded, Constructed, OBJECT_BYTES,
    body_fixture, load_native, pointer, storage)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT/'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = 'fadff73b78ac68cd5fa8896d484e2928fe5b9fcc9a551e2e46cf9937f51df353'
CODE = [
    (0x40b34a,0x40b6c0,'d19c52b189ce8e04c8eaf1950a557a4748716ea8925ac2e086fe5a73f8ce9f82'),
    (0x40c404,0x40c446,'91d1793c0449a2b52c4c86258ffd406650621dfe2a8c832a91ecf3cd79fac220'),
    (0x48905b,0x48945b,'dec6ed30bb68f52ce12da80e7bbcc975b623c34f9481db1705dccfedaf4662b8'),
    (0x410a68,0x410aaa,'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
]
INPUT=0x20000000
DATA=0x30000000
OWNER=DATA+0x1000
SLOT=DATA+0x2000
CURSOR=DATA+0x2400
OFFSET=DATA+0x2404
OUT=DATA+0x5000
STACK=0x5800
STOP=0x51000000
ALLOCATOR=0x51dc43
DEPENDENCY_BOUNDARY=0x410a68


def sha(b):
    return hashlib.sha256(b).hexdigest()


class Original:
    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE
        from unicorn import x86_const as x
        self.r={name:getattr(x,'UC_X86_REG_'+name) for name in
                ('EAX','EBX','ECX','EDX','ESI','EDI','EBP','ESP','EIP','EFLAGS','ES')}
        self.uc=Uc(UC_ARCH_X86,UC_MODE_32)
        self.uc.mem_map(pe.image_base, (pe.size_of_image+4095)&~4095)
        self.uc.mem_write(pe.image_base,pe.image)
        self.uc.mem_map(0x1000,0x10000)
        self.uc.mem_map(INPUT,0x20000)
        self.uc.mem_map(DATA,0x30000)
        self.uc.reg_write(self.r['ES'],0)
        self.allocations=0
        self.sizes=Counter()
        self.seed=bytes([0xCD])*OBJECT_BYTES
        self.uc.hook_add(UC_HOOK_CODE,self.allocate,begin=ALLOCATOR,end=ALLOCATOR)

    def allocate(self,uc,address,_size,_data):
        if address!=ALLOCATOR:
            raise RuntimeError('unexpected hook')
        esp=uc.reg_read(self.r['ESP'])
        ret,n=struct.unpack('<II',uc.mem_read(esp,8))
        if n!=OBJECT_BYTES:
            raise RuntimeError(f'unexpected allocation size {n}')
        uc.mem_write(OUT-16,b'\xa5'*16+self.seed+b'\xd7'*16)
        uc.reg_write(self.r['EAX'],OUT)
        uc.reg_write(self.r['ESP'],esp+4)  # cdecl caller removes the argument
        uc.reg_write(self.r['EIP'],ret)
        self.allocations+=1
        self.sizes[n]+=1

    def invoke(self,body,seed,payload=None,payload_offset=50):
        uc,r=self.uc,self.r
        self.seed=seed
        if len(seed)!=OBJECT_BYTES:
            raise RuntimeError('invalid allocation seed')
        loader=payload is not None
        source=payload if loader else bytes(50)+body
        body_va=INPUT+16+50
        uc.mem_write(INPUT,b'\xa6'*16+source+b'\xd6'*16)
        owner=0x619935 if loader else OWNER
        slot=0x5bb5e5 if loader else SLOT
        owner_before=b'\x5a'*0x100
        uc.mem_write(owner-16,b'\x91'*16+owner_before+b'\x92'*16)
        if bytes(uc.mem_read(0x63a4cd,2))!=bytes(2):
            raise RuntimeError('pinned original diagnostic flag is nonzero')
        uc.mem_write(0x5c39e3,bytes(2))
        if loader:
            uc.mem_write(0x5bb5b3,bytes(0x8d))
        else:
            uc.mem_write(slot-16,b'\x93'*16+b'\x69'*0x100+b'\x94'*16)
            uc.mem_write(CURSOR,struct.pack('<II',body_va,payload_offset))
        args=(INPUT+16,len(source)) if loader else (slot,CURSOR,OFFSET)
        stack_args=struct.pack('<'+'I'*(len(args)+1),STOP,*args)
        uc.mem_write(STACK-0x1000,b'\x3c'*16)
        uc.mem_write(STACK+32,b'\x7e'*16)
        uc.mem_write(STACK,stack_args)
        initial=dict(EAX=0x11111111,EBX=0x22222222,ECX=owner,
                     EDX=0x33333333,ESI=0x44444444,EDI=0x55555555,EBP=0x66666666)
        for name,value in initial.items():uc.reg_write(r[name],value)
        uc.reg_write(r['ESP'],STACK)
        uc.reg_write(r['EFLAGS'],0x202)
        entry,boundary=(0x40b34a,DEPENDENCY_BOUNDARY) if loader else (0x48905b,STOP)
        before=self.allocations
        uc.emu_start(entry,boundary,count=1000000)
        if uc.reg_read(r['EIP'])!=boundary or self.allocations!=before+1:
            raise RuntimeError('original did not reach boundary with one allocation')
        if loader:
            ebp=uc.reg_read(r['EBP'])
            cursor=struct.unpack('<I',uc.mem_read(ebp-0x20,4))[0]
            offset=struct.unpack('<I',uc.mem_read(ebp-0xcc,4))[0]
            if bytes(uc.mem_read(0x5bb5e3,2))!=bytes([0x36,payload[49]]):
                raise RuntimeError('original runtime normalization/subtype mismatch')
        else:
            cursor,offset=struct.unpack('<II',uc.mem_read(CURSOR,8))
            if uc.reg_read(r['ESP'])!=STACK+16:
                raise RuntimeError('constructor RET cleanup mismatch')
            for name in ('EBX','ESI','EDI','EBP'):
                if uc.reg_read(r[name])!=initial[name]:
                    raise RuntimeError('constructor changed callee-saved register')
        owner_after=bytearray(owner_before)
        owner_after[0x1c:0x24]=struct.pack('<II',OUT,OUT)
        guards=[(INPUT,b'\xa6'*16),(INPUT+16,source),
                (INPUT+16+len(source),b'\xd6'*16),(OUT-16,b'\xa5'*16),
                (OUT+OBJECT_BYTES,b'\xd7'*16),(owner-16,b'\x91'*16),
                (owner,bytes(owner_after)),(owner+0x100,b'\x92'*16),
                (STACK-0x1000,b'\x3c'*16),(STACK,stack_args),(STACK+32,b'\x7e'*16)]
        if not loader:
            guards.extend([(slot-16,b'\x93'*16),(slot+4,b'\x69'*0xfc),
                           (slot+0x100,b'\x94'*16)])
        for address,value in guards:
            if bytes(uc.mem_read(address,len(value)))!=value:
                raise RuntimeError(f'original source/owner/slot/stack/allocation guard changed at {address:#x}')
        if struct.unpack('<I',uc.mem_read(slot,4))[0]!=OUT:
            raise RuntimeError('original result slot did not receive allocation')
        return bytes(uc.mem_read(OUT,OBJECT_BYTES)),cursor-body_va,offset


def compare(lib,machine,body,seed,ordinal,payload=None,payload_offset=50):
    raw=storage(body);allocation=storage(seed);d=Decoded();native=Constructed()
    if lib.action_family_38_decode(raw,len(body),C.byref(d))!=0:
        raise RuntimeError(f'native decoder rejected record {ordinal}')
    start,end=struct.unpack_from('<hh',body,0x33)
    frames=end-start+1
    typed=71+frames*16
    name=body[:33].split(b'\0')[0]
    if bytes(d.name)!=name+bytes(33-len(name)):
        raise RuntimeError(f'decoded name mismatch record {ordinal}')
    for off in range(0x21,0x33,2):
        if getattr(d,f'option_{off:02x}')!=struct.unpack_from('<H',body,off)[0]:
            raise RuntimeError(f'decoded option mismatch record {ordinal}')
    if (d.frame_start,d.frame_end,tuple(d.fixed_rect))!=(start,end,struct.unpack_from('<4i',body,0x37)):
        raise RuntimeError(f'decoded signed fields mismatch record {ordinal}')
    if (pointer(d.frame_records),d.frame_count,pointer(d.dependency_records),d.body_bytes,
        d.dependency_count,d.dependency_bytes,d.available_body_bytes)!=(C.addressof(raw)+71,
        frames,C.addressof(raw)+typed,typed,(len(body)-typed)//16,len(body)-typed,len(body)):
        raise RuntimeError(f'decoded body/frame/tail mismatch record {ordinal}')
    handle=0x38000001
    result=lib.action_family_38_construct(raw,len(body),allocation,len(allocation),
                                        payload_offset,handle,C.byref(native))
    if result!=0:
        raise RuntimeError(f'native constructor rejected record {ordinal}: {result}')
    original,advance,offset=machine.invoke(body,seed,payload,payload_offset)
    image=bytes(native.object_bytes)
    if image!=original:
        diff=next(i for i,(a,b) in enumerate(zip(image,original)) if a!=b)
        raise RuntimeError(f'original/native object mismatch record {ordinal} byte {diff:#x}')
    if (advance,offset)!=(typed,(payload_offset+typed)&0xffffffff):
        raise RuntimeError(f'original body rule mismatch record {ordinal}')
    if (native.body_bytes_consumed,native.payload_offset_before,native.payload_offset_after,
        pointer(native.dependency_records),native.dependency_count,native.dependency_bytes,
        native.available_body_bytes)!=(advance,payload_offset,offset,C.addressof(raw)+typed,
                                      (len(body)-typed)//16,len(body)-typed,len(body)):
        raise RuntimeError(f'original/native cursor/tail mismatch record {ordinal}')
    links=native.owner_links
    if (links.output_handle,links.result_slot_handle,links.owner_slot_1c_handle,
        links.owner_slot_20_handle,links.output_allocation_bytes)!=(handle,handle,handle,handle,OBJECT_BYTES):
        raise RuntimeError(f'original/native owner link mismatch record {ordinal}')
    if bytes(allocation)!=seed or bytes(raw)!=body:
        raise RuntimeError('native modified an input')
    return image,original


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--native-library',type=Path,default=ROOT/'outputs/blackmoor-decomp/build/libactionfamily38.dylib')
    ap.add_argument('--result',type=Path)
    args=ap.parse_args()
    result_path=args.result
    if result_path is None:
        result_path=Path(tempfile.mkdtemp(prefix='A-38.1.oracle-',dir=PRIVATE))/'report.json'
    if result_path.exists():raise RuntimeError('result path must be unique')
    started=time.monotonic()
    manifest_bytes=(ROOT/'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes=(PRIVATE/'A-38.1.corpus.json').read_bytes()
    if sha(manifest_bytes)!=MANIFEST_HASH or sha(corpus_bytes)!=CORPUS_HASH:
        raise RuntimeError('pinned corpus/manifest hash mismatch')
    manifest,corpus=json.loads(manifest_bytes),json.loads(corpus_bytes)
    if (manifest['archive_sha256'],corpus['archive_sha256'],corpus['exe_sha256'],
        corpus['manifest_sha256'],corpus['raw_0x38_records'],len(corpus['records']))!=(
        ARCHIVE_HASH,ARCHIVE_HASH,EXE_HASH,MANIFEST_HASH,425,425):
        raise RuntimeError('corpus identity/count mismatch')
    resources={}
    for resource in manifest['resources']:
        index=int(resource['index'])
        data=(ROOT/'work/analysis/hiff-resources'/f'{index:04d}.bin').read_bytes()
        if len(data)!=resource['size'] or sha(data)!=resource['sha256']:
            raise RuntimeError(f'resource manifest mismatch: {index}')
        resources[index]=data
    if len(resources)!=2267:raise RuntimeError('resource coverage mismatch')
    pe=PEImage.parse_and_map(ROOT/'work/original/GAME.EXE')
    if sha(pe.data)!=EXE_HASH:raise RuntimeError('executable mismatch')
    for start,end,digest in CODE:
        if sha(pe.image[start-pe.image_base:end-pe.image_base])!=digest:
            raise RuntimeError(f'code window mismatch: {start:#x}')
    machine=Original(pe);lib=load_native(args.native_library)
    native_digest=hashlib.sha256();original_digest=hashlib.sha256()
    bodies=hashlib.sha256();tails=hashlib.sha256();frame_tables=hashlib.sha256()
    counts=Counter();subtypes=Counter()
    for ordinal,row in enumerate(corpus['records']):
        data=resources[row['resource_index']]
        p,n=row['act_payload_offset'],row['act_payload_length']
        payload=data[p:p+n];body=payload[50:]
        start,end=struct.unpack_from('<hh',body,0x33)
        frames=end-start+1;typed=71+frames*16
        if (row['raw_body_offset'],row['raw_body_length'],row['body_sha256'],payload[48],
            payload[49],row['typed_body_length'],row['frame_count'],row['dependency_tail_length'],
            row['dependency_tail_records'])!=(p+50,len(body),sha(body),0x38,row['subtype'],
                typed,frames,len(body)-typed,(len(body)-typed)//16):
            raise RuntimeError(f'corpus row source mismatch: {ordinal}')
        if (row['prefix_sha256'],row['frame_table_sha256'],row['dependency_tail_sha256'])!=(
            sha(body[:71]),sha(body[71:typed]),sha(body[typed:])):
            raise RuntimeError(f'corpus row span hash mismatch: {ordinal}')
        # A different deterministic allocator image per record detects extra
        # zeroing as well as missing writes anywhere in the entire allocation.
        seed=bytes((i*19+ordinal*31+7)&255 for i in range(OBJECT_BYTES))
        native,original=compare(lib,machine,body,seed,ordinal,payload)
        native_digest.update(native);original_digest.update(original)
        bodies.update(body);tails.update(body[typed:]);frame_tables.update(body[71:typed])
        counts[frames]+=1;subtypes[payload[49]]+=1
    synthetic=[]
    for i,(start,count,name,tail) in enumerate([
        (1,0,b'',0),(-32768,1,b'one',1),(-99,100,bytes(range(1,33)),8),
        (32668,100,b'positive',0),(-32768,100,b'negative',2),
        (-3,4,b'cross-zero',1),(32767,1,b'upper',0),(32767,0,b'zero-upper',2)]):
        body=body_fixture(start=start,count=count,name=name,tail=tail)
        seed=bytes([0xCD if i%2 else 0])*OBJECT_BYTES
        offset=0xfffffffb if i%2 else 50
        image,_=compare(lib,machine,body,seed,f'synthetic-direct-{i}',payload_offset=offset)
        # Also execute subtype preservation through the full original loader.
        subtype=2 if i%2 else 1
        payload=b'synthetic'+bytes(39)+bytes([0x38,subtype])+body
        compare(lib,machine,body,seed,f'synthetic-loader-{i}',payload)
        synthetic.append(dict(start=start,count=count,subtype=subtype,tail_records=tail,
                              payload_offset=offset,object_sha256=sha(image)))
    result=dict(slice='A-38.1',scope='original loader to 0x410a68 and direct constructor; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH,manifest_sha256=MANIFEST_HASH,archive_sha256=ARCHIVE_HASH,
                    corpus_sha256=CORPUS_HASH,resources_verified=len(resources),code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),
        oracle_script_sha256=sha(Path(__file__).read_bytes()),
        corpus_records=425,synthetic_records=len(synthetic),synthetic_original_calls=2*len(synthetic),
        original_calls=machine.allocations,mismatches=0,
        corpus_object_bytes_compared=425*OBJECT_BYTES,corpus_object_sha256=native_digest.hexdigest(),
        original_object_sha256=original_digest.hexdigest(),corpus_raw_bodies_sha256=bodies.hexdigest(),
        corpus_dependency_tails_sha256=tails.hexdigest(),corpus_frame_tables_sha256=frame_tables.hexdigest(),
        frame_count_distribution=dict(counts),subtype_distribution=dict(subtypes),synthetic=synthetic,
        hooks={hex(ALLOCATOR):'allocation boundary only: exactly 0xABA bytes with caller-specified prior contents and guards'},
        allocation_sizes=dict(machine.sizes),stop_boundaries=[hex(DEPENDENCY_BOUNDARY),hex(STOP)],
        deliberate_safety_rejections=['negative or >100 frame counts; no original malformed-input parity claimed',
            'short body/table, non-16-byte tail, missing name terminator, null/overlap/span wrap, invalid seed/handle'],
        unverified=['allocation failure/fatal diagnostics','nonzero diagnostic flag',
            'generic dependency construction/evaluation','runtime/lifecycle/render/host effects',
            'live subtype behavior beyond constructor preservation','whole-file matching and native gameplay'],
        elapsed_seconds=round(time.monotonic()-started,3))
    with result_path.open('x') as output:output.write(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(corpus_records=425,synthetic_records=len(synthetic),original_calls=machine.allocations,
        object_bytes_compared=425*OBJECT_BYTES,mismatches=0,result=str(result_path),
        result_sha256=sha(result_path.read_bytes()))))
    return 0


if __name__=='__main__':
    raise SystemExit(main())
