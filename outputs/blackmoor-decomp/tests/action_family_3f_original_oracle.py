#!/usr/bin/env python3
"""Execute immutable raw-0x3f loader and CONVO lookup, never a native decision.

Only malloc is replaced. Read/write hooks observe arena/input bounds and do not
alter decisions. Stop at 0x410a68, before generic dependency construction. Whole
allocations preserve arbitrary supplied initial bytes. No gameplay claim.
"""
from __future__ import annotations
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import tempfile
import time
from autotext_original_oracle import (OriginalAutoText, OracleError, _read_cvtx_payload,
    parse_entries, TABLE_VA, ALLOCATOR_VA, STACK_TOP, RETURN_VA)
from hiff_original_oracle import PEImage
import test_action_family_3f as native

ROOT=Path(__file__).resolve().parents[3]
PROJECT=Path(__file__).resolve().parents[1]
PRIVATE=ROOT/'work/analysis/slices'
EXE_HASH='afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH='440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH='1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH='6c879d935c4132d21ee26095aedd4c15e50d3a4769c6cc5bec80b70f54f4cd48'
CODE=[(0x40b34a,0x40b506,'814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
      (0x40c142,0x40c186,'9b5db4cf2b7cb9f8eeffa6adf04df2a4261d4b09fbded342e9f58cc9dcbadd24'),
      (0x41c509,0x41db40,'2aba12d956ffcf9462664e912f6c96b839a0e0308c0de3c5607ba2a679824633'),
      (0x410a68,0x410aaa,'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
      (0x423097,0x423310,'b4eb9d4bd2626ef764debef61ed18527e99f74cba4e337cc4eecd469a8ca42e5')]
INPUT=0x24000000
ACT=INPUT+16
ARENA=0x26000000
ARENA_SIZE=0x4000000
TABLE=0x6187b9
SLOT=0x5bb5b3
BOUNDARY=0x410a68

def sha(data):return hashlib.sha256(data).hexdigest()

class Original3f(OriginalAutoText):
    def __init__(self):
        self.action_active=False
        self.allocations=[]
        self.fill=0xcd
        super().__init__(ROOT/'work/original/GAME.EXE')
        from unicorn import UC_HOOK_MEM_WRITE,UC_HOOK_MEM_READ
        self.machine.mem_map(INPUT,0x800000)
        self.machine.mem_map(ARENA-0x1000,ARENA_SIZE+0x2000)
        self.machine.hook_add(UC_HOOK_MEM_WRITE,self._observe_arena,
                             begin=ARENA-16,end=ARENA+ARENA_SIZE+15)
        self.machine.hook_add(UC_HOOK_MEM_READ,self._observe_input,begin=INPUT,end=INPUT+0x7fffff)

    def _observe_input(self,uc,_access,address,size,_value,_user):
        if self.action_active and not ACT <= address <= ACT+len(self.current_act)-size:
            raise OracleError(f'original input read outside fixture at {address:#x}')

    def _observe_arena(self,uc,_access,address,size,_value,_user):
        if self.action_active and not any(a <= address and address+size <= a+n for a,n in self.allocations):
            raise OracleError(f'original write outside allocated span at {address:#x}')

    def _on_code(self,uc,address,size,user):
        if not self.action_active:
            return super()._on_code(uc,address,size,user)
        if address != ALLOCATOR_VA:raise OracleError('unexpected intercept')
        esp=uc.reg_read(self._reg['ESP'])
        n=struct.unpack('<I',uc.mem_read(esp+4,4))[0]
        a=(self.action_cursor+3)&~3
        if n==0 or a+n>ARENA+ARENA_SIZE:raise OracleError('malloc limit')
        uc.mem_write(a,bytes([self.fill])*n)
        self.action_cursor=a+n;self.allocations.append((a,n))
        uc.reg_write(self._reg['EAX'],a)
        self._return_from_intercepted_call(uc)

    def install_table(self,entries):
        self.initialize()
        for entry in entries:self.insert(entry['key_field'],entry['raw_value'])
        self.machine.mem_write(TABLE,bytes(self.machine.mem_read(TABLE_VA,4096)))

    def run(self,act,fill=0xcd,offset=50):
        if len(act)>0x700000:raise OracleError('fixture too large')
        uc,r=self.machine,self._reg
        self.current_act=act;self.fill=fill;self.allocations=[];self.action_cursor=ARENA
        uc.mem_write(INPUT,b'\xa6'*16+act+b'\xd6'*16)
        uc.mem_write(SLOT-16,b'\xb7'*16+b'\x5a'*0x8d+b'\xe8'*16)
        uc.mem_write(0x5c39e3,b'\0\0')
        if bytes(uc.mem_read(0x63a4cd,2))!=b'\0\0':raise OracleError('original debug flag nonzero')
        uc.mem_write(STACK_TOP-0x1000,b'\x71'*16)
        uc.mem_write(STACK_TOP+12,b'\x82'*16)
        args=struct.pack('<III',RETURN_VA,ACT,len(act));uc.mem_write(STACK_TOP,args)
        for key in ('EAX','EBX','ECX','EDX','ESI','EDI','EBP'):uc.reg_write(r[key],0)
        uc.reg_write(r['ESP'],STACK_TOP);uc.reg_write(r['EFLAGS'],0x202)
        start=0x40b34a
        if offset!=50:
            # Bounded original arm entry: same caller locals/slot as loader.
            start=0x40c142;frame=STACK_TOP-4
            uc.reg_write(r['EBP'],frame);uc.reg_write(r['ESP'],frame-0x244)
            uc.mem_write(frame-0x20,struct.pack('<I',ACT+50))
            uc.mem_write(frame-0xcc,struct.pack('<I',offset))
            uc.mem_write(SLOT+0x30,act[48:50])
        self.action_active=True
        try:uc.emu_start(start,BOUNDARY,count=200_000_000,timeout=180_000_000)
        finally:self.action_active=False
        if uc.reg_read(r['EIP'])!=BOUNDARY:raise OracleError(f'loader failed to reach handoff: EIP={uc.reg_read(r["EIP"]):#x}, allocations={len(self.allocations)}')
        if not self.allocations or self.allocations[0]!=(ARENA,1957):raise OracleError('main allocation mismatch')
        frame=uc.reg_read(r['EBP'])
        slot=bytes(uc.mem_read(SLOT,0x8d))
        if slot[0x30:0x32]!=act[48:50] or struct.unpack_from('<I',slot,0x32)[0]!=ARENA:
            raise OracleError('original type/subtype/slot mismatch')
        if slot[0x36:]!=b'\x5a'*(0x8d-0x36):raise OracleError('original changed slot runtime fields')
        for pos,expected in ((INPUT,b'\xa6'*16),(ACT,act),(ACT+len(act),b'\xd6'*16),
                (SLOT-16,b'\xb7'*16),(SLOT+0x8d,b'\xe8'*16),
                (STACK_TOP-0x1000,b'\x71'*16),(STACK_TOP,args),(STACK_TOP+12,b'\x82'*16)):
            if bytes(uc.mem_read(pos,len(expected)))!=expected:raise OracleError('original input/slot/stack guard changed')
        if uc.reg_read(r['ESP'])!=frame-0x244:raise OracleError('original stack imbalance')
        advance=struct.unpack('<I',uc.mem_read(frame-0x20,4))[0]-ACT-50
        endoffset=struct.unpack('<I',uc.mem_read(frame-0xcc,4))[0]
        return [(a-ARENA,bytes(uc.mem_read(a,n))) for a,n in self.allocations],advance,endoffset

def resolve(body,table):
    values=[];cursor=77;count=struct.unpack_from('<h',body,75)[0]
    offsets=[35]
    for _ in range(count):
        n=body[cursor];cursor+=2+5*n;offsets.append(cursor);cursor+=68
    for offset in offsets:
        key=body[offset:offset+33].split(b'\0')[0].lower()
        if key not in table:raise OracleError('missing fixture text key')
        values.append(table[key])
    return values

def compare(lib,machine,act,table,expected_length=None,fill=0xcd,offset=50):
    body=act[50:];src=native.storage(body);d=native.Decoded();out=native.Constructed()
    if lib.action_family_3f_decode(src,len(src),C.byref(d))!=0:raise OracleError('native decoder rejected')
    values=resolve(body,table);rows,keep=native.texts(values)
    if lib.action_family_3f_construct(src,len(src),rows,len(rows),offset,ARENA,None,0,C.byref(out))!=0:
        raise OracleError('native layout query rejected')
    arena=native.storage(bytes([fill])*(out.arena_bytes+32));guard=bytes(arena[-32:])
    if lib.action_family_3f_construct(src,len(src),rows,len(rows),offset,ARENA,arena,out.arena_bytes,C.byref(out))!=0:
        raise OracleError('native constructor rejected')
    objects,advance,endoffset=machine.run(act,fill,offset)
    if len(objects)!=out.allocation_count or objects[-1][0]+len(objects[-1][1])!=out.arena_bytes:
        raise OracleError('allocation rule mismatch')
    mine=hashlib.sha256();original=hashlib.sha256();total=0
    for a,image in objects:
        got=bytes(arena[a:a+len(image)])
        if got!=image:
            first=next(i for i,(x,y) in enumerate(zip(got,image)) if x!=y)
            raise OracleError(f'original/native allocation mismatch: offset {a:#x}, byte {first:#x}: {got[first]:02x}/{image[first]:02x}')
        total+=len(image);mine.update(got);original.update(image)
    if bytes(arena[-32:])!=guard:raise OracleError('native arena guard changed')
    if advance!=d.body_bytes or advance!=out.body_bytes_consumed or endoffset!=out.payload_offset_after:
        raise OracleError('cursor/body rule mismatch')
    if expected_length is not None and advance!=expected_length:raise OracleError('corpus rule mismatch')
    if (d.dependency_records,d.dependency_bytes,d.dependency_count,d.available_body_bytes)!=(
            C.addressof(src)+advance,len(body)-advance,(len(body)-advance)//16,len(body)):
        raise OracleError('native borrowed dependency view mismatch')
    primary=struct.unpack_from('<h',body,75)[0]
    if (d.raw_type,d.runtime_type,d.primary_count)!=(0x3f,0x3f,primary):raise OracleError('decoded type/count mismatch')
    expect=(struct.unpack_from('<H',body,33)[0],body[68],body[69],body[70],
            struct.unpack_from('<H',body,71)[0],struct.unpack_from('<H',body,73)[0])
    if (d.option_21,d.option_44,d.option_45,d.option_46,d.word_47,d.word_49)!=expect:
        raise OracleError('decoded neutral fields mismatch')
    for decoded,start in ((bytes(d.name),0),(bytes(d.text_key),35)):
        name=body[start:start+33].split(b'\0')[0]
        if decoded!=name+bytes(33-len(name)):raise OracleError('decoded name/key mismatch')
    cursor=77
    for _ in range(primary):cursor+=70+body[cursor]*5
    secondary=body[cursor];secstart=cursor+2;cursor=secstart
    for _ in range(secondary):cursor+=6+body[cursor]*5
    if (d.primary_records,d.primary_bytes,d.secondary_count,d.secondary_records,d.secondary_bytes)!=(
        C.addressof(src)+77,secstart-79,secondary,C.addressof(src)+secstart,cursor-secstart):
        raise OracleError('decoded record views mismatch')
    return total,len(objects),mine.digest(),original.digest()

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--native-library',type=Path,default=PROJECT/'build/libactionfamily3f.dylib')
    ap.add_argument('--result',type=Path)
    args=ap.parse_args();started=time.monotonic()
    if args.result is None:
        args.result=Path(tempfile.mkdtemp(prefix='A-3F.1.oracle-',dir=PRIVATE))/'result.json'
    manifest_bytes=(ROOT/'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes=(PRIVATE/'A-3F.1.corpus.json').read_bytes()
    if sha(manifest_bytes)!=MANIFEST_HASH or sha(corpus_bytes)!=CORPUS_HASH:raise OracleError('manifest/corpus digest mismatch')
    manifest=json.loads(manifest_bytes);corpus=json.loads(corpus_bytes)
    if manifest['archive_sha256']!=ARCHIVE_HASH or len(corpus['records'])!=493:raise OracleError('archive/count mismatch')
    resources={}
    for row in manifest['resources']:
        b=(ROOT/'work/analysis/hiff-resources'/f'{int(row["index"]):04d}.bin').read_bytes()
        if len(b)!=row['size'] or sha(b)!=row['sha256']:raise OracleError('resource size/hash mismatch')
        resources[int(row['index'])]=b
    if (len(resources),corpus['scen_data_records'],corpus['scene_actions'])!=(2267,2078,19612):
        raise OracleError('corpus coverage mismatch')
    exe=(ROOT/'work/original/GAME.EXE').read_bytes()
    if sha(exe)!=EXE_HASH:raise OracleError('executable identity mismatch')
    pe=PEImage.parse_and_map(ROOT/'work/original/GAME.EXE')
    for a,z,digest in CODE:
        if sha(pe.image[a-pe.image_base:z-pe.image_base])!=digest:raise OracleError('code hash mismatch')
    entries=parse_entries(_read_cvtx_payload(resources[64]));table={}
    for entry in entries:table.setdefault(entry['key'].lower(),entry['caption'])
    # Synthetic lookup entries are inserted with original routines.
    extra={b'KEY':b'synthetic caption',b'KMAX':b'x'*1499,b'KCHOICE':b'y'*399,b'EMPTY':b''}
    entries+= [dict(key_field=k.ljust(33,b'\0'),raw_value=v+b'\0') for k,v in extra.items()]
    table.update({k.lower():v for k,v in extra.items()})
    machine=Original3f();machine.install_table(entries);lib=native.load_native(args.native_library)
    corpus_bytes_compared=corpus_allocations=total=allocations=0
    native_digest=hashlib.sha256();original_digest=hashlib.sha256()
    for row in corpus['records']:
        data=resources[row['resource_index']];start=row['act_payload_offset']
        act=data[start:start+row['act_payload_length']]
        if act[48]!=0x3f or act[49]!=row['subtype'] or sha(act[50:])!=row['body_sha256']:
            raise OracleError('ACT/header/body identity mismatch')
        n,k,nd,od=compare(lib,machine,act,table,row['typed_body_length'])
        corpus_bytes_compared+=n;corpus_allocations+=k;native_digest.update(nd);original_digest.update(od)
    synth=[(native.fixture(),0xcd,50),(native.fixture((0,1,127),(0,1,127),2),0x7b,50),
           (native.fixture((0,)*32767),0xa5,50),(native.fixture((),(0,)*127),0x35,50),
           (native.fixture((0,),(0,),3),0x5a,0xfffffff0)]
    maximum=bytearray(native.fixture((0,)));maximum[35:68]=b'KMAX'+bytes(29)
    maximum[79:112]=b'KCHOICE'+bytes(26);synth.append((bytes(maximum),0x21,50))
    empty=bytearray(native.fixture((0,)));empty[35:68]=b'EMPTY'+bytes(28)
    empty[79:112]=b'EMPTY'+bytes(28);synth.append((bytes(empty),0x99,50))
    full_names=bytearray(native.fixture((0,)));full_names[:33]=b'N'*32+b'\0'
    full_names[112:145]=b'M'*32+b'\0';synth.append((bytes(full_names),0x91,50))
    for raw,fill,offset in synth:
        act=b'synthetic'.ljust(48,b'\0')+b'\x3f\x02'+raw
        n,k,nd,od=compare(lib,machine,act,table,fill=fill,offset=offset)
        total+=n;allocations+=k;native_digest.update(nd);original_digest.update(od)
    result=dict(slice='A-3F.1',status='pass',mismatches=0,exe_sha256=EXE_HASH,
        manifest_sha256=MANIFEST_HASH,archive_sha256=ARCHIVE_HASH,corpus_sha256=CORPUS_HASH,
        code_windows=[dict(start=hex(a),end=hex(z),sha256=h) for a,z,h in CODE],
        native_library_sha256=sha(args.native_library.read_bytes()),native_source_sha256=sha((PROJECT/'src/action_family_3f.c').read_bytes()),
        corpus_records=493,synthetic_cases=len(synth),original_native_calls=493+len(synth),
        resources_verified=2267,convo_entries=1244,synthetic_convo_entries=4,
        corpus_allocations=corpus_allocations,synthetic_allocations=allocations,
        corpus_object_bytes_compared=corpus_bytes_compared,synthetic_object_bytes_compared=total,
        native_object_digest=native_digest.hexdigest(),original_object_digest=original_digest.hexdigest(),
        hooks=[dict(address='0x51dc43',kind='replacement',purpose='bounded malloc only; caller-supplied initial fill and aligned model handles'),
               dict(range='0x25fffff0..0x2a00000f',kind='observation',purpose='reject original writes outside allocated spans; never changes execution'),
               dict(range='0x24000000..0x247fffff',kind='observation',purpose='check original reads stay within ACT fixture')],
        stop_boundary='0x410a68 before generic dependency construction',
        table_initialization='original 0x423097/0x423142; installed CONVO table at 0x6187b9',
        original_decisions_replaced=False,whole_game_equivalence=False,
        elapsed_seconds=round(time.monotonic()-started,3))
    args.result.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('status','corpus_records','synthetic_cases','original_native_calls','mismatches','elapsed_seconds')}))
    print('receipt',args.result)

if __name__=='__main__':main()
