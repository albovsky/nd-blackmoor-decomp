#!/usr/bin/env python3
"""Original raw44 loader/constructor/lookup and dependency-prefix decisions.

Only malloc is replaced. Original lookup and decision code executes unchanged.
Unique private reports; no original file writes, game launch or GUI.
"""
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import tempfile
import time
from autotext_original_oracle import (OriginalAutoText, OracleError, _read_cvtx_payload,
    parse_entries, TABLE_VA, ALLOCATOR_VA, STACK_TOP, RETURN_VA, KEY_VA, VALUE_VA, INSERT_VA)
from hiff_original_oracle import PEImage
import test_action_family_44 as native

ROOT=Path(__file__).resolve().parents[3]
PROJECT=Path(__file__).resolve().parents[1]
PRIVATE=ROOT/'work/analysis/slices'
EXE_HASH='afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH='440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH='1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH='cb5d0cdc472211747289c03b6ea99f91386518c055aa5f182f1b8eef37f4b792'
CODE_WINDOWS_HASH='6a8471f523971d1cfa465ca4a9a3073d122f31b74ec596903fe297ff03291b03'
INPUT=0x24000000
ACT=INPUT+16
ARENA=0x26000000
ARENA_SIZE=0x100000
TABLE=0x619a6b
SLOT=0x5bb5b3
BOUNDARY=0x410a68

def sha(data):return hashlib.sha256(data).hexdigest()

def require(condition,message):
    if not condition:raise OracleError(message)

class Original44(OriginalAutoText):
    def __init__(self):
        self.action_active=False
        self.allocations=[]
        self.fill=0xcd
        super().__init__(ROOT/'work/original/GAME.EXE')
        from unicorn import UC_HOOK_MEM_WRITE,UC_HOOK_MEM_READ,UC_HOOK_CODE
        self.machine.mem_map(INPUT,0x800000)
        self.machine.mem_map(ARENA-0x1000,ARENA_SIZE+0x2000)
        self.machine.hook_add(UC_HOOK_MEM_WRITE,self._observe_arena,
                             begin=ARENA-16,end=ARENA+ARENA_SIZE+15)
        self.machine.hook_add(UC_HOOK_MEM_READ,self._observe_input,begin=INPUT,end=INPUT+0x7fffff)
        self.machine.hook_add(UC_HOOK_MEM_WRITE,self._observe_source,begin=INPUT,end=INPUT+0x7fffff)
        self.machine.hook_add(UC_HOOK_CODE,self._stop_constructor,begin=BOUNDARY,end=BOUNDARY)
        self.dependency_active=False
        for point in (0x424c94,0x424c5b,0x425b84):
            self.machine.hook_add(UC_HOOK_CODE,self._stop_dependency,begin=point,end=point)

    def _stop_constructor(self,uc,_address,_size,_user):
        if self.action_active:uc.emu_stop()

    def _observe_source(self,uc,_access,address,size,_value,_user):
        if self.action_active:
            if self.current_act[50+492] != 0 or address != ACT+50+526 or size != 2:
                raise OracleError('unexpected original source write')
            self.source_writes += 1

    def _stop_dependency(self,uc,address,_size,_user):
        if self.dependency_active:
            self.dependency_stop=address
            uc.emu_stop()

    def dependency(self,tail,consumed,total):
        uc,r=self.machine,self._reg
        # Fresh dependency slot as supplied by the scene loader; decisions run
        # in the unchanged original up to the three branch-specific exits.
        uc.mem_write(SLOT+0x36,bytes(0x8d-0x36))
        uc.mem_write(INPUT,b'\xa6'*16+tail+b'\xd6'*16)
        uc.mem_write(STACK_TOP,struct.pack('<5I',RETURN_VA,SLOT,consumed,total,ACT))
        for key in ('EAX','EBX','EDX','ESI','EDI','EBP'):uc.reg_write(r[key],0)
        uc.reg_write(r['ECX'],0x63786d);uc.reg_write(r['ESP'],STACK_TOP)
        uc.reg_write(r['EFLAGS'],0x202)
        self.dependency_stop=None;self.dependency_active=True
        try:uc.emu_start(0x424aa8,RETURN_VA,count=100000)
        finally:self.dependency_active=False
        if self.dependency_stop not in (0x424c94,0x424c5b,0x425b84):
            raise OracleError('original dependency decision did not reach a classified exit')
        count=struct.unpack('<I',uc.mem_read(SLOT+0x6a,4))[0]
        if bytes(uc.mem_read(ACT,len(tail))) != tail:
            raise OracleError('original dependency prefix changed input')
        return self.dependency_stop != 0x424c5b,count,self.dependency_stop


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
        self.current_act=act;self.source_writes=0;self.fill=fill;self.allocations=[];self.action_cursor=ARENA
        uc.mem_write(INPUT,b'\xa6'*16+act+b'\xd6'*16)
        uc.mem_write(SLOT-16,b'\xb7'*16+bytes(0x8d)+b'\xe8'*16)
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
            start=0x40c4b5;frame=STACK_TOP-4
            uc.reg_write(r['EBP'],frame);uc.reg_write(r['ESP'],frame-0x244)
            uc.mem_write(frame-0x20,struct.pack('<I',ACT+50))
            uc.mem_write(frame-0xcc,struct.pack('<I',offset))
            uc.mem_write(frame-0x108,struct.pack('<I',1))
            uc.mem_write(frame-0xf8,struct.pack('<I',1))
            uc.mem_write(SLOT+0x30,act[48:50])
        self.action_active=True
        try:uc.emu_start(start,BOUNDARY,count=200_000_000,timeout=180_000_000)
        except Exception as exc:
            raise OracleError(f'original loader trap: EIP={uc.reg_read(r["EIP"]):#x}, mode={act[542]}, offset={offset:#x}, allocations={self.allocations}: {exc}') from exc
        finally:self.action_active=False
        if uc.reg_read(r['EIP'])!=BOUNDARY:raise OracleError(f'loader failed to reach handoff: EIP={uc.reg_read(r["EIP"]):#x}, allocations={len(self.allocations)}')
        if len(self.allocations)!=1 or self.allocations[0][0]!=ARENA:raise OracleError('main allocation mismatch')
        frame=uc.reg_read(r['EBP'])
        slot=bytes(uc.mem_read(SLOT,0x8d))
        if slot[0x30:0x32]!=act[48:50] or struct.unpack_from('<I',slot,0x32)[0]!=ARENA:
            raise OracleError('original type/subtype/slot mismatch')
        if slot[0x36:]!=bytes(0x8d-0x36):raise OracleError('original changed slot runtime fields')
        source=bytes(uc.mem_read(ACT,len(act)))
        if source[:576] != act[:576] or source[578:] != act[578:]:
            raise OracleError('original changed unexpected input bytes')
        if (act[542]!=0 and source!=act) or self.source_writes != (1 if act[542]==0 else 0):
            raise OracleError('original source write count mismatch')
        for pos,expected in ((INPUT,b'\xa6'*16),(ACT+len(act),b'\xd6'*16),
                (SLOT-16,b'\xb7'*16),(SLOT+0x8d,b'\xe8'*16),
                (STACK_TOP-0x1000,b'\x71'*16),(STACK_TOP,args),(STACK_TOP+12,b'\x82'*16)):
            if bytes(uc.mem_read(pos,len(expected)))!=expected:raise OracleError('original input/slot/stack guard changed')
        if uc.reg_read(r['ESP'])!=frame-0x244:raise OracleError('original stack imbalance')
        advance=struct.unpack('<I',uc.mem_read(frame-0x20,4))[0]-ACT-50
        endoffset=struct.unpack('<I',uc.mem_read(frame-0xcc,4))[0]
        # Execute caller argument preparation, stopping before the CALL only
        # to verify what the unchanged loader forwards to the tail routine.
        uc.emu_start(BOUNDARY,0x410aa5,count=1000)
        forwarded=struct.unpack('<4I',uc.mem_read(uc.reg_read(r['ESP']),16))
        if forwarded!=(SLOT,endoffset,len(act),ACT+50+advance):
            raise OracleError('original dependency handoff argument mismatch')
        return bytes(uc.mem_read(ARENA,self.allocations[0][1])),advance,endoffset,source


def compare(lib,machine,act,text,offset=50,fill=0xcd):
    body=act[50:];raw=native.storage(body);d=native.Decoded();c=native.Constructed()
    original,advance,endoffset,source=machine.run(act,offset=offset,fill=fill)
    require(lib.action_family_44_decode(raw,len(raw),C.byref(d))==0,'native decoder rejected valid original')
    length=C.c_size_t(999)
    require(lib.action_family_44_body_length(raw,len(raw),C.byref(length))==0 and length.value==advance,
            'native body-length helper mismatch')
    require((d.body_bytes,d.available_body_bytes,d.dependency_records,d.dependency_bytes,d.dependency_count)==
        (advance,len(body),C.addressof(raw)+advance,len(body)-advance,(len(body)-advance)//16),
        'decoded body/tail mismatch')
    word,count=struct.unpack_from('<H',body,2)[0],struct.unpack_from('<H',body,526)[0]
    require((d.word_02,d.word_20e,d.option_1ec,d.raw_type,d.runtime_type)==
        (word,count,body[492],0x44,0x44),'decoded neutral field mismatch')
    text_start=528 if body[492]==0 else 493
    extent=count if body[492]==0 else 33
    text_length=body.index(0,text_start,text_start+extent)-text_start
    require((d.header,d.text,d.text_bytes)==(C.addressof(raw),C.addressof(raw)+text_start,text_length),
            'decoded borrowed field mismatch')
    resolved=native.storage(text+b'\0') if text is not None else None
    resolved_bytes=len(resolved) if resolved is not None else 0
    require(lib.action_family_44_construct(raw,len(raw),resolved,resolved_bytes,offset,ARENA,None,0,C.byref(c))==0,
            'native layout query rejected')
    arena=native.storage(bytes([fill])*(c.object_bytes+32))
    require(lib.action_family_44_construct(raw,len(raw),resolved,resolved_bytes,offset,ARENA,arena,c.object_bytes,C.byref(c))==0,
            'native constructor rejected valid original')
    mine=bytes(arena[:c.object_bytes])
    require(mine==original,'original/native allocation mismatch')
    require(bytes(arena[c.object_bytes:])==bytes([fill])*32,'native allocation guard changed')
    require((c.object_bytes,c.body_bytes_consumed,c.payload_offset_before,c.payload_offset_after,c.result_slot_handle)==
        (len(original),advance,offset,endoffset,ARENA),'constructor size/cursor/constant mismatch')
    require((c.dependency_records,c.dependency_count,c.dependency_bytes,c.available_body_bytes)==
        (C.addressof(raw)+advance,(len(body)-advance)//16,len(body)-advance,len(body)),
        'constructor tail metadata mismatch')
    require((c.word_20e_after,c.source_word_20e_after,c.source_word_20e_written,c.raw_type,c.runtime_type)==
        (struct.unpack_from('<H',original,526)[0],struct.unpack_from('<H',source,576)[0],
         machine.source_writes,act[48],act[48]),'constructor field/source-write mismatch')
    require(bytes(raw)==body,'native changed input')
    return mine,original,advance


def tail_compare(lib,machine,body,advance):
    raw=native.storage(body);d=native.Decoded();length=C.c_size_t(999)
    accepted,count,point=machine.dependency(body[advance:],50+advance,50+len(body))
    status=lib.action_family_44_decode(raw,len(raw),C.byref(d))
    helper=lib.action_family_44_body_length(raw,len(raw),C.byref(length))
    require((status==0)==accepted and (helper==0)==accepted,'original/native tail acceptance mismatch')
    if accepted:
        require(d.dependency_count==count,'original/native dependency count mismatch')
        require(length.value==advance and d.body_bytes==advance,'native body-length helper mismatch')
    else:
        require(status==native.TAIL and helper==native.TAIL and length.value==999,
                'native malformed tail status/atomicity mismatch')
    return point


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--native-library',type=Path,default=PROJECT/'build/libactionfamily44.dylib')
    ap.add_argument('--result',type=Path)
    args=ap.parse_args();started=time.monotonic()
    result=args.result or Path(tempfile.mkdtemp(prefix='A-44.1.oracle-',dir=PRIVATE))/'report.json'
    require(not result.exists(),'result path must be unique')
    mb=(ROOT/'work/analysis/hiff-resources.json').read_bytes();cb=(PRIVATE/'A-44.1.corpus.json').read_bytes()
    require(sha(mb)==MANIFEST_HASH and sha(cb)==CORPUS_HASH,'pinned manifest/corpus mismatch')
    manifest,corpus=json.loads(mb),json.loads(cb)
    require(manifest['archive_sha256']==ARCHIVE_HASH,'archive identity mismatch')
    resources={}
    for row in manifest['resources']:
        b=(ROOT/'work/analysis/hiff-resources'/f'{int(row["index"]):04d}.bin').read_bytes()
        require(len(b)==row['size'] and sha(b)==row['sha256'],'resource identity mismatch')
        resources[int(row['index'])]=b
    require((len(resources),corpus['scen_data_records'],corpus['scene_actions'],len(corpus['records']))==
        (2267,2078,19612,27),'corpus coverage mismatch')
    pe=PEImage.parse_and_map(ROOT/'work/original/GAME.EXE');require(sha(pe.data)==EXE_HASH,'executable mismatch')
    code_bytes=(PRIVATE/'A-44.1.code-windows.json').read_bytes()
    require(sha(code_bytes)==CODE_WINDOWS_HASH,'pinned code-window receipt mismatch')
    windows=json.loads(code_bytes)
    for row in windows:
        a,z=int(row['start'],16),int(row['end_exclusive'],16)
        require(sha(pe.image[a-pe.image_base:z-pe.image_base])==row['sha256'],'code range hash mismatch')
    entries=parse_entries(_read_cvtx_payload(resources[1]));table={}
    for row in entries:table.setdefault(row['key'].lower(),row['caption'])
    extra={b'KEY':b'synthetic caption',b'EMPTY':b'',b'LONG':b'x'*39998}
    entries += [dict(key_field=k.ljust(33,b'\0'),raw_value=v+b'\0') for k,v in extra.items()]
    table.update({k.lower():v for k,v in extra.items()})
    machine=Original44();machine.install_table(entries);lib=native.load_native(args.native_library)
    # Larger strings are outside the resource table loader's 40000-byte buffer,
    # but valid for this constructor. Insert via unchanged original 0x423142.
    for key,n in ((b'SIGNED',32768),(b'MAXIMUM',40000)):
        value=b'z'*n
        machine.machine.mem_write(KEY_VA,key.ljust(33,b'\0'))
        machine.machine.mem_write(VALUE_VA,value+b'\0')
        machine._call(INSERT_VA,(KEY_VA,VALUE_VA),TABLE_VA,'synthetic long insert')
        table[key.lower()]=value
    machine.machine.mem_write(TABLE,bytes(machine.machine.mem_read(TABLE_VA,4096)))
    mine=hashlib.sha256();original=hashlib.sha256();compared=0;calls=0;tail_points={}
    for row in corpus['records']:
        b=resources[row['resource_index']];start=row['act_payload_offset'];act=b[start:start+row['act_payload_length']]
        require(act[48:50]==bytes([0x44,row['subtype']]) and sha(act[50:])==row['body_sha256'],
                'corpus ACT identity mismatch')
        key=act[543:576].split(b'\0')[0].lower();require(key in table,'corpus key unresolved')
        nd,od,advance=compare(lib,machine,act,table[key]);require(advance==row['typed_body_length'],'corpus boundary mismatch')
        mine.update(nd);original.update(od);compared+=len(od);calls+=1
        point=tail_compare(lib,machine,act[50:],advance);tail_points[hex(point)]=tail_points.get(hex(point),0)+1
    corpus_bytes_compared=compared
    synth=[(native.fixture(0,b'\0'),None,50),(native.fixture(0,b'a\0junk',tail=1),None,50),
        (native.fixture(0,b'x'*32766+b'\0',tail=2),None,50),
        (native.fixture(0,word=65535),None,0xfffffff0),
        (native.fixture(mode=255,key=b'KEY',count=65535,word=65535),table[b'key'],50),
        (native.fixture(key=b'EMPTY'),b'',50),(native.fixture(key=b'SIGNED'),table[b'signed'],50),
        (native.fixture(key=b'MAXIMUM'),table[b'maximum'],50),(native.fixture(key=b'LONG'),table[b'long'],50)]
    for body,text,offset in synth:
        act=b'synthetic'.ljust(48,b'\0')+b'\x44\x02'+body
        nd,od,_=compare(lib,machine,act,text,offset=offset,fill=0x71)
        mine.update(nd);original.update(od);compared+=len(od);calls+=1
    # Constructor advances are observed independently of native tail rejection.
    for n in range(41):
        body=native.fixture()+bytes((i*17+3)&255 for i in range(n))
        act=b'tail'.ljust(48,b'\0')+b'\x44\x01'+body
        _,advance,_,_=machine.run(act)
        point=tail_compare(lib,machine,body,advance);tail_points[hex(point)]=tail_points.get(hex(point),0)+1
    # Unsafe-original inputs are native safety cases, not parity claims.
    malformed=[(native.fixture()[:n],native.BODY) for n in range(528)]
    malformed += [(native.fixture(0,count=n),native.BODY) for n in (32768,65535)]
    malformed += [(native.fixture(0,b'ab\0',count=4),native.BODY),
        (native.fixture(0,b''),native.TEXT),(native.fixture(0,b'abc'),native.TEXT),
        (native.fixture(key=b'k'*33),native.TEXT)]
    for body,status in malformed:
        raw=native.storage(body);d=native.Decoded();length=C.c_size_t(999)
        C.memset(C.byref(d),0xa5,C.sizeof(d));before=bytes(d)
        require(lib.action_family_44_decode(raw,len(raw),C.byref(d))==status and bytes(d)==before,
                'native short-body/safety rejection mismatch')
        require(lib.action_family_44_body_length(raw,len(raw),C.byref(length))==status and length.value==999,
                'native short-body helper rejection mismatch')
    hooks=[dict(address='0x51dc43',kind='replacement',purpose='bounded successful malloc only; original table and object allocations'),
        dict(range='0x24000000..0x247fffff',kind='observer',purpose='exact ACT read bounds; only inline source WORD+526 writes permitted'),
        dict(range='0x25fffff0..0x2610000f',kind='observer',purpose='object writes must stay inside original allocation'),
        dict(address='0x410a68',kind='stop',purpose='constructor handoff; prevents cached-block end-address drift'),
        dict(addresses=['0x424c94','0x424c5b','0x425b84'],kind='stop',purpose='observe original accept/reject/empty-tail exits after stored count; no decision replacement')]
    report=dict(slice='A-44.1',status='pass',mismatches=0,exe_sha256=EXE_HASH,manifest_sha256=MANIFEST_HASH,
        archive_sha256=ARCHIVE_HASH,corpus_sha256=CORPUS_HASH,code_windows=windows,
        native_library_sha256=sha(args.native_library.read_bytes()),oracle_sha256=sha(Path(__file__).read_bytes()),
        native_source_sha256=sha((PROJECT/'src/action_family_44.c').read_bytes()),corpus_records=27,
        corpus_scenes=10,synthetic_constructor_cases=len(synth),original_native_constructor_calls=calls,
        original_tail_decisions=68,tail_exit_counts=tail_points,synthetic_tail_lengths=list(range(41)),
        additional_original_loader_tail_calls=41,native_safety_rejections=len(malformed),
        corpus_object_bytes_compared=corpus_bytes_compared,object_bytes_compared=compared,
        native_object_digest=mine.hexdigest(),original_object_digest=original.hexdigest(),
        resources_verified=len(resources),autotext_entries=1257,synthetic_lookup_entries=5,
        table_initialization='original 0x423097/0x423142; owner table at 0x619a6b',
        hooks=hooks,original_decisions_replaced=False,whole_game_equivalence=False,
        original_constructor_boundary='0x410a68; forwarded args observed at 0x410aa5',
        elapsed_seconds=round(time.monotonic()-started,3))
    with result.open('x') as out:out.write(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k] for k in ('status','corpus_records','synthetic_constructor_cases',
        'original_native_constructor_calls','original_tail_decisions','native_safety_rejections','mismatches','elapsed_seconds')}))
    print('receipt',result)

if __name__=='__main__':main()
