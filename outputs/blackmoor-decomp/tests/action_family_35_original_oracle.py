#!/usr/bin/env python3
"""A-35.1: original instructions from ACT loader to dependency-stage boundary.

Use work/tools/oracle-python/bin/python with Unicorn JIT permitted. The only
replacement is successful guarded allocation at 0x51dc43. Switch selection,
count reads/arithmetic, allocation request, byte copying and both cursor writes
all execute original instructions. No playback or dependency decisions run.
"""
import argparse
import ctypes as C
import hashlib
import json
import struct
import time
from collections import Counter
from pathlib import Path

from cif_original_oracle import PEImage, align_up
from test_action_family_35 import (Decoded, Constructed, Record6, Record34,
    MAX_BODY, MAX_COUNT, fixture, storage, load_native)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '1dc946bf742b3e64bf0b7823629a8001840b51aaae79f0709811928a8dd23617'
CODE = [
    (0x40b34a,0x40b506,'814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x40c3a8,0x40c3d6,'25b073f405627aa54bd9e44103e576647a7eeb371329ae67f8b95c9d73fca09b'),
    (0x410ca4,0x410f89,'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x4bf8c2,0x4bf9bb,'7d158bdf34fe0129dfc3c0d488dfe5d325275ad225a14ee8167f62242083b27a'),
    (0x410a68,0x410aaa,'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
]
INPUT = 0x24000000
OUTPUT = 0x25000010
STACK = 0x1000
STACK_TOP = STACK + 0xc000
ALLOCATOR = 0x51dc43
BOUNDARY = 0x410a68
OWNER = 0x637fcf
SLOT = 0x5bb5b3
HOOKS = [{'address':'0x51dc43','kind':'allocation boundary',
          'behavior':'Return guarded caller storage for one positive allocation, preserving requested size; cdecl return.',
          'excluded':'Allocation failure, OS heap internals and fatal-error path.'}]


def sha(data): return hashlib.sha256(data).hexdigest()


class OriginalLoader:
    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE
        from unicorn.x86_const import (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX,
            UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI, UC_X86_REG_EBP,
            UC_X86_REG_ESP, UC_X86_REG_EIP, UC_X86_REG_EFLAGS, UC_X86_REG_ES)
        self.reg = dict(zip(('eax','ebx','ecx','edx','esi','edi','ebp','esp','eip','flags'),
            (UC_X86_REG_EAX,UC_X86_REG_EBX,UC_X86_REG_ECX,UC_X86_REG_EDX,
             UC_X86_REG_ESI,UC_X86_REG_EDI,UC_X86_REG_EBP,UC_X86_REG_ESP,
             UC_X86_REG_EIP,UC_X86_REG_EFLAGS)))
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.uc.mem_map(pe.image_base,align_up(pe.size_of_image))
        self.uc.mem_write(pe.image_base,pe.image)
        self.uc.mem_map(INPUT,align_up(MAX_BODY+4096))
        self.uc.mem_map(OUTPUT-16,align_up(MAX_BODY+4096))
        self.uc.mem_map(STACK,0x10000)
        self.uc.reg_write(UC_X86_REG_ES,0)
        self.allocations=[]
        self.uc.hook_add(UC_HOOK_CODE,self.allocate,begin=ALLOCATOR,end=ALLOCATOR)

    def allocate(self, uc, address, _size, _data):
        if address != ALLOCATOR: raise RuntimeError('unexpected hook')
        esp=uc.reg_read(self.reg['esp'])
        ret,requested=struct.unpack('<II',uc.mem_read(esp,8))
        if requested < 63 or requested > MAX_BODY:
            raise RuntimeError(f'original allocation outside safe count domain: {requested}')
        uc.mem_write(OUTPUT-16,b'\xa5'*16+b'\xcd'*requested+b'\xd7'*16)
        self.allocations.append(requested)
        uc.reg_write(self.reg['eax'],OUTPUT)
        uc.reg_write(self.reg['esp'],esp+4)
        uc.reg_write(self.reg['eip'],ret)

    def invoke(self, payload, direct_offset=None):
        uc,r=self.uc,self.reg
        uc.mem_write(INPUT,b'\xa6'*16+payload+b'\xd6'*16)
        uc.mem_write(SLOT,bytes(0x8d))
        uc.mem_write(0x5c39e3,b'\0\0')
        if bytes(uc.mem_read(0x63a4cd,2)) != b'\0\0':
            raise RuntimeError('unexpected original debug flag')
        owner_before=bytes(uc.mem_read(OWNER,0x300))
        uc.mem_write(STACK_TOP-0x1000,b'\x3c'*16)
        uc.mem_write(STACK_TOP+32,b'\x7e'*16)
        for i,key in enumerate(('eax','ebx','ecx','edx','esi','edi','ebp'),1):
            uc.reg_write(r[key],i*0x11111111)
        uc.reg_write(r['esp'],STACK_TOP);uc.reg_write(r['flags'],0x202)
        if direct_offset is None:
            args=struct.pack('<III',0x30000000,INPUT+16,len(payload))
            start,stop=0x40b34a,BOUNDARY
        else:
            # Also prove direct constructor DWORD-offset wrap and owner neutrality.
            uc.mem_write(SLOT+0x30,payload[48:50])
            uc.mem_write(STACK+0x100,struct.pack('<II',INPUT+16+50,direct_offset))
            args=struct.pack('<IIII',0x30000000,SLOT+0x32,STACK+0x100,STACK+0x104)
            uc.reg_write(r['ecx'],OWNER)
            start,stop=0x4bf8c2,0x30000000
        uc.mem_write(STACK_TOP,args)
        before=len(self.allocations)
        try:
            uc.emu_start(start,stop,count=4000000)
        except Exception as error:
            raise RuntimeError(f'original emulation failed at {uc.reg_read(r["eip"]):#x}, '
                f'esp={uc.reg_read(r["esp"]):#x}, edi={uc.reg_read(r["edi"]):#x}: {error}') from error
        if uc.reg_read(r['eip']) != stop or len(self.allocations) != before+1:
            raise RuntimeError('original failed to reach boundary with exactly one allocation')
        n=self.allocations[-1]
        if direct_offset is None:
            ebp=uc.reg_read(r['ebp'])
            cursor,offset=(struct.unpack('<I',uc.mem_read(ebp+x,4))[0] for x in (-0x20,-0xcc))
        else:
            cursor,offset=struct.unpack('<II',uc.mem_read(STACK+0x100,8))
            if uc.reg_read(r['esp']) != STACK_TOP+16:
                raise RuntimeError('original constructor did not pop three arguments')
        slot_ptr=struct.unpack('<I',uc.mem_read(SLOT+0x32,4))[0]
        types=bytes(uc.mem_read(SLOT+0x30,2))
        if slot_ptr != OUTPUT or types != payload[48:50]:
            raise RuntimeError('pData identity or original raw/runtime type/subtype differs')
        if bytes(uc.mem_read(OWNER,0x300)) != owner_before:
            raise RuntimeError('constructor unexpectedly mutated its owner')
        for addr,expect in [(INPUT,b'\xa6'*16),(INPUT+16,payload),
                (INPUT+16+len(payload),b'\xd6'*16),(OUTPUT-16,b'\xa5'*16),
                (OUTPUT+n,b'\xd7'*16),(STACK_TOP-0x1000,b'\x3c'*16),
                (STACK_TOP,args),(STACK_TOP+32,b'\x7e'*16)]:
            if bytes(uc.mem_read(addr,len(expect))) != expect:
                raise RuntimeError(f'input/allocation/stack guard changed at {addr:#x}')
        return bytes(uc.mem_read(OUTPUT,n)),cursor-(INPUT+16+50),offset,types[0]


def compare(lib,machine,body,payload,label,direct_offset=None):
    original,advance,offset,runtime_type=machine.invoke(payload,direct_offset)
    # Expected values are read from the complete original-created allocation.
    n=struct.unpack_from('<h',original,59)[0]
    second=61+6*n
    m=struct.unpack_from('<h',original,second)[0]
    if advance != len(original): raise RuntimeError('original cursor/allocation mismatch')
    src=storage(body);d=Decoded();meta=Constructed()
    obj=(C.c_uint8*(MAX_BODY+16))();C.memset(obj,0xcc,len(obj))
    if lib.action_family_35_decode(src,len(body),C.byref(d)) != 0:
        raise RuntimeError(f'native decoder rejected {label}')
    expected=(original[:33],struct.unpack_from('<13H',original,33),n,m,
        C.addressof(src)+61,C.addressof(src)+second+2,C.addressof(src)+advance,
        (len(body)-advance)//16,len(body)-advance,len(body),advance,0x35,runtime_type)
    actual=(bytes(d.name),tuple(d.words),d.count_6,d.count_34,d.records_6,d.records_34,
        d.dependency_records,d.dependency_count,d.dependency_bytes,d.available_body_bytes,d.body_bytes,
        d.raw_type,d.runtime_type)
    if actual != expected: raise RuntimeError(f'decoded field/view mismatch {label}')
    for count,stride,start,typ,fn in [(n,6,61,Record6,lib.action_family_35_record6_at),
            (m,34,second+2,Record34,lib.action_family_35_record34_at)]:
        # Every corpus element; bounded edge elements in 32767-count synthetic arrays.
        indices=range(count) if count<=32 else (0,count//2,count-1)
        for idx in indices:
            rec=typ()
            if fn(src,len(body),idx,C.byref(rec)) != 0 or tuple(rec.words) != struct.unpack_from(
                    '<'+'H'*(stride//2),original,start+idx*stride):
                raise RuntimeError(f'decoded array mismatch {label} stride={stride} index={idx}')
    initial_offset=50 if direct_offset is None else direct_offset
    status=lib.action_family_35_construct(src,len(body),initial_offset,OUTPUT,obj,len(obj),C.byref(meta))
    if status != 0: raise RuntimeError(f'native constructor rejected {label}: {status}')
    image=bytes(obj[:meta.allocation_bytes])
    if image != original: raise RuntimeError(f'whole original/native object mismatch {label}')
    if bytes(obj[meta.allocation_bytes:]) != b'\xcc'*(len(obj)-meta.allocation_bytes):
        raise RuntimeError(f'native output guard changed {label}')
    if (meta.body_bytes_consumed,meta.allocation_bytes,meta.payload_offset_before,meta.payload_offset_after,
        meta.result_slot_handle,meta.raw_type,meta.runtime_type,meta.dependency_records,
        meta.dependency_count,meta.dependency_bytes,meta.available_body_bytes) != (
            advance,len(original),initial_offset,offset,OUTPUT,0x35,runtime_type,
            C.addressof(src)+advance,(len(body)-advance)//16,len(body)-advance,len(body)):
        raise RuntimeError(f'original/native metadata mismatch {label}')
    return original


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--native-library',type=Path,default=ROOT/'outputs/blackmoor-decomp/build/libactionfamily35.dylib')
    ap.add_argument('--result',type=Path,default=PRIVATE/'A-35.1.original-oracle.json')
    args=ap.parse_args();started=time.monotonic()
    pe=PEImage.parse_and_map(ROOT/'work/original/GAME.EXE')
    if sha(pe.data)!=EXE_HASH: raise RuntimeError('original executable hash mismatch')
    windows=[]
    for start,end,digest in CODE:
        if sha(pe.image[start-pe.image_base:end-pe.image_base])!=digest:
            raise RuntimeError('original code window hash mismatch')
        windows.append(dict(start=hex(start),end_exclusive=hex(end),sha256=digest))
    ix=pe.image[0x410e9c+0x35-10-pe.image_base]
    if struct.unpack_from('<I',pe.image,0x410ca4+4*ix-pe.image_base)[0]!=0x40c3a8:
        raise RuntimeError('raw 0x35 switch table differs')
    cb=(PRIVATE/'A-35.1.corpus.json').read_bytes()
    mb=(ROOT/'work/analysis/hiff-resources.json').read_bytes()
    if sha(cb)!=CORPUS_HASH or sha(mb)!=MANIFEST_HASH: raise RuntimeError('census/manifest hash mismatch')
    corpus,manifest=json.loads(cb),json.loads(mb)
    if (manifest['archive_sha256']!=ARCHIVE_HASH or corpus['archive_sha256']!=ARCHIVE_HASH
            or corpus['exe_sha256']!=EXE_HASH or corpus['manifest_sha256']!=MANIFEST_HASH
            or corpus['resources_scanned']!=2267 or corpus['scen_data_records']!=2078
            or corpus['scene_actions']!=19612 or corpus['raw_0x35_records']!=113
            or len(corpus['records'])!=113):
        raise RuntimeError('census identity/count mismatch')
    # Verify every resource before any corpus oracle execution.
    resources={}
    for row in manifest['resources']:
        idx=int(row['index']);data=(ROOT/'work/analysis/hiff-resources'/f'{idx:04d}.bin').read_bytes()
        if len(data)!=row['size'] or sha(data)!=row['sha256']: raise RuntimeError(f'resource hash mismatch {idx}')
        resources[idx]=data
    if len(resources)!=2267: raise RuntimeError('resource count mismatch')
    machine=OriginalLoader(pe);lib=load_native(args.native_library)
    digest=hashlib.sha256();byte_count=0;results=[]
    for row in corpus['records']:
        data=resources[row['resource_index']]
        payload=data[row['act_payload_offset']:row['act_payload_offset']+row['act_payload_length']]
        body=payload[50:]
        if (len(payload)!=row['act_payload_length'] or payload[48]!=0x35
                or payload[49]!=row['subtype'] or len(body)!=row['raw_body_length']
                or sha(body)!=row['body_sha256']): raise RuntimeError('row/header/body hash mismatch')
        label=f"corpus {row['resource_index']}:{row['action_index']}"
        original=compare(lib,machine,body,payload,label)
        if len(original)!=row['typed_body_length']:raise RuntimeError('census/original boundary mismatch')
        digest.update(original);byte_count+=len(original)
        results.append({'resource_index':row['resource_index'],'action_index':row['action_index'],
            'object_bytes':len(original),'object_sha256':sha(original),'mismatches':0})
    synthetic=[];synthetic_bytes=0
    cases=[(0,0,0,True,1),(1,0,16,True,1),(0,1,32,True,2),
           (3,4,0,True,255),(1,1,0,False,1),(MAX_COUNT,0,0,True,1),
           (0,MAX_COUNT,0,True,1),(MAX_COUNT,MAX_COUNT,16,True,1)]
    for i,(n,m,tail,terminated,subtype) in enumerate(cases):
        body=fixture(n,m,tail,terminated);payload=b'fixture'+bytes(41)+bytes([0x35,subtype])+body
        original=compare(lib,machine,body,payload,f'synthetic {i}')
        synthetic_bytes+=len(original)
        synthetic.append(dict(count_6=n,count_34=m,tail_bytes=tail,name_terminated=terminated,
            subtype=subtype,object_bytes=len(original),object_sha256=sha(original)))
    for initial in (0,0xfffffff0):
        body=fixture(1,1,16);payload=bytes(48)+b'\x35\x02'+body
        original=compare(lib,machine,body,payload,'direct offset wrap',initial)
        synthetic_bytes+=len(original)
        synthetic.append(dict(direct_payload_offset=initial,object_bytes=len(original),object_sha256=sha(original)))
    result=dict(slice='A-35.1',status='pass',scope='isolated body decode/allocation; no gameplay or x86 byte match',
        exe_sha256=EXE_HASH,manifest_sha256=MANIFEST_HASH,archive_sha256=ARCHIVE_HASH,
        corpus_sha256=CORPUS_HASH,code_windows=windows,resources_verified=len(resources),
        corpus_records=len(results),corpus_object_bytes=byte_count,
        corpus_object_stream_sha256=digest.hexdigest(),synthetic_cases=len(synthetic),
        synthetic_object_bytes=synthetic_bytes,mismatches=0,allocation_hook_calls=len(machine.allocations),
        hook_inventory=HOOKS,execution_boundary=hex(BOUNDARY),rows=results,synthetic=synthetic,
        native_sha256=sha(args.native_library.read_bytes()),oracle_sha256=sha(Path(__file__).read_bytes()),
        source_sha256=sha((ROOT/'outputs/blackmoor-decomp/src/action_family_35.c').read_bytes()),
        seconds=round(time.monotonic()-started,3),
        safety_rejections='Malformed/negative/overlap cases are native-only safety evidence, not valid-original parity.',
        unverified_branches=['allocation failure/fatal handling','nonzero debug logging',
            'negative signed counts (native rejection)','generic dependency parser/evaluator',
            'runtime lifecycle/playback/render/host behavior','subtype gameplay behavior'])
    args.result.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('status','resources_verified','corpus_records','corpus_object_bytes',
        'synthetic_cases','synthetic_object_bytes','mismatches','native_sha256','seconds')}))


if __name__=='__main__':main()
