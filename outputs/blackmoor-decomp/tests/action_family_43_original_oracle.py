#!/usr/bin/env python3
"""Immutable x86 raw43 loader/constructor and original AUTOTEXT lookup.

Only malloc is replaced; observation hooks enforce exact fixture/allocation
bounds. Stops before generic dependencies. Unique reports, no resource dumps.
Run with work/tools/oracle-python/bin/python and Unicorn JIT permitted.
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
from autotext_original_oracle import (OriginalAutoText, OracleError, _read_cvtx_payload,
    parse_entries, TABLE_VA, ALLOCATOR_VA, STACK_TOP, RETURN_VA, KEY_VA, VALUE_VA, INSERT_VA)
from hiff_original_oracle import PEImage
from test_action_family_43 import Decoded, Constructed, body_fixture, load_native, pointer, storage

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '2d95f4bc387a6ada1261dc94bd3ea8c60fac55a27bd69edc3de9d8d4f0c0b284'
CODE = [
    (0x40b34a, 0x40b506, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'),
    (0x410ca4, 0x410f89, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'),
    (0x40c487, 0x40c4b5, '6380583a0a7f9b119f29c4d205a7ca45dc37987d4ce7cbc9dad65891051917cf'),
    (0x41137f, 0x41166e, '543f0a6228cc60dbd94f1ecc0ff90035600e5103a0d3ffe5e75893798be68123'),
    (0x410a68, 0x410aaa, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'),
    (0x423097, 0x42345c, '843275d48e1d685603fa204cff3ddd69f5bd99f0fb3fd8f6de790e95a33b001a'),
    (0x424aa8, 0x424d17, '13e355b494656486571152d851e51578a7408fdb4f49e889f6a28a42ea45f581'),
]
INPUT, ACT, OBJECT = 0x24000000, 0x24000010, 0x26000010
SLOT, OWNER, TABLE, BOUNDARY = 0x5bb5b3, 0x619a41, 0x619a6b, 0x410a68
CURSOR, OFFSET, DIRECT_SLOT = 0x26011000, 0x26011004, 0x26011008


def sha(data): return hashlib.sha256(data).hexdigest()


class Original43(OriginalAutoText):
    def __init__(self):
        self.action_active = False
        self.allocations = []
        self.input_writes = []
        super().__init__(ROOT / 'work/original/GAME.EXE')
        from unicorn import UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
        self.machine.mem_map(INPUT, 0x20000)
        self.machine.mem_map(OBJECT-16, 0x20000)
        self.machine.hook_add(UC_HOOK_MEM_READ, self.observe_input_read, begin=INPUT, end=INPUT+0x1ffff)
        self.machine.hook_add(UC_HOOK_MEM_WRITE, self.observe_input_write, begin=INPUT, end=INPUT+0x1ffff)
        self.machine.hook_add(UC_HOOK_MEM_WRITE, self.observe_object_write, begin=OBJECT-16, end=OBJECT+40318)
        self.constructor_calls = 0
        self.loader_calls = 0
        self.direct_calls = 0

    def observe_input_read(self, _uc, _access, address, size, _value, _user):
        if self.action_active and not ACT <= address <= ACT+len(self.current_act)-size:
            raise OracleError(f'original input read outside exact fixture: {address:#x}, size {size}')

    def observe_input_write(self, _uc, _access, address, size, value, _user):
        if self.action_active:
            if self.current_act[50+265] != 0 or (address,size) != (ACT+50+299,2):
                raise OracleError('unexpected original input write')
            self.input_writes.append((address-ACT, size, value & 65535))

    def observe_object_write(self, _uc, _access, address, size, _value, _user):
        if self.action_active and not any(a <= address and address+size <= a+n for a,n in self.allocations):
            raise OracleError(f'original write outside allocated span: {address:#x}')

    def _on_code(self, uc, address, size, user):
        if not self.action_active:
            return super()._on_code(uc,address,size,user)
        if address != ALLOCATOR_VA: raise OracleError('unexpected intercept')
        esp = uc.reg_read(self._reg['ESP'])
        n = struct.unpack('<I',uc.mem_read(esp+4,4))[0]
        if self.allocations or n < 301 or n > 40302:
            raise OracleError(f'original allocation outside safe domain: {n}')
        # The original size decision has executed. The hook only supplies storage.
        uc.mem_write(OBJECT-16, b'\x91'*16 + bytes([self.fill])*n + b'\xe7'*16)
        self.allocations.append((OBJECT,n))
        uc.reg_write(self._reg['EAX'],OBJECT)
        self._return_from_intercepted_call(uc)

    def install_table(self, entries, synthetic):
        self.initialize()
        for entry in entries: self.insert(entry['key_field'],entry['raw_value'])
        for key, text in synthetic:
            if len(key)>32 or not text.endswith(b'\0') or b'\0' in text[:-1]:
                raise OracleError('unsafe synthetic table fixture')
            # Original insert executes even for exactly 40000 visible bytes;
            # inherited helper restricts its resource buffer to <40000 bytes.
            self.machine.mem_write(KEY_VA, key+bytes(33-len(key)))
            self.machine.mem_write(VALUE_VA, text)
            self._call(INSERT_VA,(KEY_VA,VALUE_VA),TABLE_VA,'synthetic entry insert')
        self.machine.mem_write(TABLE,bytes(self.machine.mem_read(TABLE_VA,4096)))
        self.table_allocation_calls = self._allocator_calls

    def invoke(self, act, fill=0xcd, offset=50, direct=False):
        if len(act)+32>0x20000: raise OracleError('fixture mapping limit')
        uc,r=self.machine,self._reg
        self.current_act=act; self.fill=fill; self.allocations=[]; self.input_writes=[]
        uc.mem_write(INPUT,b'\xa6'*16+act+b'\xd6'*16)
        slot = DIRECT_SLOT if direct else SLOT+0x32
        uc.mem_write(SLOT-16,b'\xb7'*16+b'\x5a'*0x8d+b'\xe8'*16)
        uc.mem_write(0x5c39e3,bytes(2))
        if bytes(uc.mem_read(0x63a4cd,2))!=bytes(2): raise OracleError('diagnostic flag not pinned zero')
        owner_before=bytes(uc.mem_read(OWNER,0x102a))
        args=struct.pack('<III',RETURN_VA,ACT,len(act))
        uc.mem_write(STACK_TOP,args)
        for name in ('EAX','EBX','ECX','EDX','ESI','EDI','EBP'): uc.reg_write(r[name],0)
        uc.reg_write(r['ESP'],STACK_TOP);uc.reg_write(r['EFLAGS'],0x202)
        if direct:
            uc.mem_write(CURSOR,struct.pack('<III',ACT+50,offset,0xdeadbeef))
            uc.mem_write(STACK_TOP,struct.pack('<IIII',RETURN_VA,slot,CURSOR,OFFSET))
            uc.reg_write(r['ECX'],OWNER)
            start,stop=0x41137f,RETURN_VA
        elif offset!=50:
            # Original arm, matching original caller frame/locals and slot.
            frame=STACK_TOP-4
            uc.reg_write(r['EBP'],frame);uc.reg_write(r['ESP'],frame-0x244)
            uc.mem_write(frame-0x20,struct.pack('<I',ACT+50))
            uc.mem_write(frame-0xcc,struct.pack('<I',offset))
            uc.mem_write(SLOT+0x30,act[48:50])
            start,stop=0x40c487,BOUNDARY
        else:
            start,stop=0x40b34a,BOUNDARY
        self.action_active=True
        try: uc.emu_start(start,stop,timeout=30_000_000,count=50_000_000)
        finally: self.action_active=False
        if uc.reg_read(r['EIP'])!=stop: raise OracleError('original constructor/loader did not reach stop')
        if len(self.allocations)!=1: raise OracleError('original allocation count mismatch')
        handle=struct.unpack('<I',uc.mem_read(slot,4))[0]
        if handle!=OBJECT: raise OracleError('original result slot mismatch')
        if direct:
            advance,endoffset=struct.unpack('<II',uc.mem_read(CURSOR,8))
            if uc.reg_read(r['ESP'])!=STACK_TOP+16: raise OracleError('direct stack imbalance')
            self.direct_calls+=1
        else:
            frame=uc.reg_read(r['EBP'])
            advance=struct.unpack('<I',uc.mem_read(frame-0x20,4))[0]
            endoffset=struct.unpack('<I',uc.mem_read(frame-0xcc,4))[0]
            if uc.reg_read(r['ESP'])!=frame-0x244: raise OracleError('loader stack imbalance')
            action_slot=bytes(uc.mem_read(SLOT,0x8d))
            expected_slot=bytearray(b'\x5a'*0x8d)
            if offset==50:
                name_bytes=act[:48].index(0)+1
                expected_slot[:name_bytes]=act[:name_bytes]
            expected_slot[48:50]=act[48:50]
            expected_slot[50:54]=struct.pack('<I',OBJECT)
            if action_slot!=expected_slot:
                raise OracleError('original header/subtype/runtime slot mismatch')
            self.loader_calls+=1
        advance-=ACT+50
        changed=bytes(uc.mem_read(ACT,len(act)))
        expected=bytearray(act)
        if act[50+265]==0:
            length=act[351:].index(0)
            struct.pack_into('<H',expected,349,length)
            if self.input_writes!=[(349,2,length)]: raise OracleError('original source-word write effect mismatch')
        elif self.input_writes: raise OracleError('keyed constructor wrote source')
        if changed!=expected: raise OracleError('original source changed beyond expected word')
        n=self.allocations[0][1]
        for position,value in ((INPUT,b'\xa6'*16),(ACT+len(act),b'\xd6'*16),
                (OBJECT-16,b'\x91'*16),(OBJECT+n,b'\xe7'*16),
                (SLOT-16,b'\xb7'*16),(SLOT+0x8d,b'\xe8'*16)):
            if bytes(uc.mem_read(position,len(value)))!=value: raise OracleError('original guard changed')
        if bytes(uc.mem_read(OWNER,0x102a))!=owner_before: raise OracleError('original owner changed')
        self.constructor_calls+=1
        return bytes(uc.mem_read(OBJECT,n)), advance, endoffset, changed[349:351], len(self.input_writes)


def compare(lib, machine, act, resolved, expected_length=None, fill=0xcd, offset=50, direct=False):
    body=act[50:];raw=storage(body);txt=storage(resolved) if resolved is not None else None
    d,c=Decoded(),Constructed()
    if lib.action_family_43_decode(raw,len(raw),C.byref(d))!=0: raise OracleError('native decoder rejected')
    args=(raw,len(raw),txt,len(resolved or b''),offset,OBJECT)
    if lib.action_family_43_construct(*args,None,0,C.byref(c))!=0: raise OracleError('native size query rejected')
    arena=storage(bytes([fill])*(c.allocation_bytes+32));guard=bytes(arena[-32:])
    if lib.action_family_43_construct(*args,arena,c.allocation_bytes,C.byref(c))!=0: raise OracleError('native constructor rejected')
    original,advance,endoffset,source_word,writes=machine.invoke(act,fill,offset,direct)
    image=bytes(arena[:c.allocation_bytes])
    if len(original)!=c.allocation_bytes: raise OracleError('original/native allocation rule mismatch')
    if image!=original: raise OracleError('original/native allocation mismatch')
    if bytes(arena[-32:])!=guard or bytes(raw)!=body: raise OracleError('native arena/input mutation mismatch')
    if (d.word_00,d.option_02,d.option_109,d.word_12b,pointer(d.prefix))!=(
            struct.unpack_from('<H',body)[0],struct.unpack_from('<h',body,2)[0],body[265],
            struct.unpack_from('<H',body,299)[0],C.addressof(raw)):
        raise OracleError('decoded neutral field mismatch')
    if body[265]:
        if d.key!=body[266:299].split(b'\0')[0] or d.inline_text or d.inline_visible_length:
            raise OracleError('decoded key branch mismatch')
    elif d.key or pointer(d.inline_text)!=C.addressof(raw)+301 or d.inline_visible_length!=body[301:].index(0):
        raise OracleError('decoded inline branch mismatch')
    tail=len(body)-advance
    if expected_length is not None and advance!=expected_length: raise OracleError('corpus body rule mismatch')
    if (d.body_bytes,d.available_body_bytes,pointer(d.dependency_records),d.dependency_bytes,d.dependency_count)!=(
            advance,len(body),C.addressof(raw)+advance,tail,tail//16):
        raise OracleError('decoded body/tail mismatch')
    if (c.body_bytes_consumed,c.available_body_bytes,c.payload_offset_before,c.payload_offset_after,
            pointer(c.dependency_records),c.dependency_count,c.dependency_bytes)!=(
            advance,len(body),offset,endoffset,C.addressof(raw)+advance,tail//16,tail):
        raise OracleError('original/native cursor/body rule mismatch')
    if endoffset!=(offset+advance)&0xffffffff: raise OracleError('original DWORD advance mismatch')
    if (c.source_word_12b_after,c.source_word_written)!=(struct.unpack('<H',source_word)[0],writes):
        raise OracleError('original/native source write effect mismatch')
    if (c.result_slot_handle,c.raw_type,c.runtime_type)!=(OBJECT,0x43,0x43):
        raise OracleError('original/native slot/type mismatch')
    return image,original


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--native-library',type=Path,default=PROJECT/'build/libactionfamily43.dylib')
    ap.add_argument('--result',type=Path)
    args=ap.parse_args();started=time.monotonic()
    result_path=args.result or Path(tempfile.mkdtemp(prefix='A-43.1.oracle-',dir=PRIVATE))/'report.json'
    if result_path.exists(): raise OracleError('result path must be unique')
    manifest_bytes=(ROOT/'work/analysis/hiff-resources.json').read_bytes()
    corpus_bytes=(PRIVATE/'A-43.1.corpus.json').read_bytes()
    if sha(manifest_bytes)!=MANIFEST_HASH or sha(corpus_bytes)!=CORPUS_HASH: raise OracleError('corpus/manifest identity mismatch')
    manifest,corpus=json.loads(manifest_bytes),json.loads(corpus_bytes)
    if (manifest['archive_sha256'],corpus['archive_sha256'],corpus['exe_sha256'],corpus['manifest_sha256'],
        corpus['resources_scanned'],corpus['scen_data_records'],corpus['scene_actions'],corpus['raw_0x43_records'],len(corpus['records']))!=(
            ARCHIVE_HASH,ARCHIVE_HASH,EXE_HASH,MANIFEST_HASH,2267,2078,19612,13,13):
        raise OracleError('corpus counts/identity mismatch')
    resources={}
    for row in manifest['resources']:
        index=int(row['index']);data=(ROOT/'work/analysis/hiff-resources'/f'{index:04d}.bin').read_bytes()
        if len(data)!=row['size'] or sha(data)!=row['sha256']: raise OracleError('resource manifest mismatch')
        resources[index]=data
    if len(resources)!=2267: raise OracleError('resource count mismatch')
    pe=PEImage.parse_and_map(ROOT/'work/original/GAME.EXE')
    if sha(pe.data)!=EXE_HASH: raise OracleError('executable mismatch')
    for a,b,digest in CODE:
        if sha(pe.image[a-pe.image_base:b-pe.image_base])!=digest: raise OracleError('code window mismatch')
    entries=parse_entries(_read_cvtx_payload(resources[1]))
    table={}
    for row in entries: table.setdefault(row['key'].lower(),row['caption']+b'\0')
    synthetic_table=[(b'fixture_empty',b'\0'),(b'fixture_short',b'hello\0'),
        (b'fixture_32767',b'x'*32767+b'\0'),(b'fixture_40000',b'y'*40000+b'\0'),
        (b'k'*32,b'z\0')]
    machine,lib=Original43(),load_native(args.native_library)
    machine.install_table(entries,synthetic_table)
    native_hash,original_hash,bodies,tails=(hashlib.sha256() for _ in range(4))
    corpus_bytes_compared=0;resolved_lengths=Counter()
    for row in corpus['records']:
        data=resources[row['resource_index']];p,n=row['act_payload_offset'],row['act_payload_length'];act=data[p:p+n];body=act[50:]
        if (act[48],act[49],len(body),row['raw_body_offset'],sha(body),sha(body[:301]),sha(body[301:]),
            row['typed_body_length'],row['dependency_tail_records'],row['dependency_tail_length'])!=(
            0x43,row['subtype'],row['raw_body_length'],p+50,row['body_sha256'],row['prefix_sha256'],
            row['dependency_tail_sha256'],301,0,0): raise OracleError('corpus row source mismatch')
        key=body[266:299].split(b'\0')[0].lower()
        if key not in table: raise OracleError('corpus AUTOTEXT key missing')
        text=table[key]; resolved_lengths[len(text)-1]+=1
        image,original=compare(lib,machine,act,text,301,fill=(row['resource_index']*17)&255)
        native_hash.update(image);original_hash.update(original);bodies.update(body);tails.update(body[301:]);corpus_bytes_compared+=len(image)
    fixtures=[]
    for i,(key,text) in enumerate(synthetic_table):
        body=body_fixture(selector=(1,2,255,1,2)[i],tail=(0,1,9,3,2)[i],count=(0,1,32767,32768,65535)[i],
                          option=(0,3,32767,-32768,-1)[i],key=key)
        fixtures.append((f'keyed-{i}',body,text))
    for i,(text,option) in enumerate(((b'\0',2),(b'a\0xyz',-1),(b'x'*32766+b'\0',-32768),(b'hello\0',0))):
        fixtures.append((f'inline-{i}',body_fixture(selector=0,inline=text,tail=(0,2,3,9)[i],option=option,key=b'x'*33),None))
    synthetic=[];synthetic_bytes_compared=0;synthetic_hash=hashlib.sha256()
    for i,(label,body,text) in enumerate(fixtures):
        act=b'synthetic'+bytes(39)+bytes([0x43,(0,1,2,255)[i%4]])+body
        # Full loader + independent constructor, including wrap and effect order.
        image,_=compare(lib,machine,act,text,fill=(i*31)&255)
        synthetic_bytes_compared+=len(image);synthetic_hash.update(image)
        image,_=compare(lib,machine,act,text,fill=255-((i*31)&255),offset=(0,50,0xfffffffe,0xffffffff)[i%4],direct=True)
        synthetic_bytes_compared+=len(image);synthetic_hash.update(image)
        synthetic.append(dict(label=label,body_sha256=sha(body),body_length=len(body),object_bytes=len(image),object_sha256=sha(image)))
    # Nondefault caller offset also checked through the unchanged original arm.
    body=body_fixture(selector=0,inline=b'a\0xyz',tail=1);act=bytes(48)+bytes([0x43,2])+body
    image,_=compare(lib,machine,act,None,offset=0xffffffff)
    synthetic_bytes_compared+=len(image);synthetic_hash.update(image)
    report=dict(slice='A-43.1',status='pass',scope='constructor + loader boundary only; raw43 runtime remains open',
        inputs=dict(exe_sha256=EXE_HASH,manifest_sha256=MANIFEST_HASH,archive_sha256=ARCHIVE_HASH,
            corpus_sha256=CORPUS_HASH,resources_verified=2267,autotext_entries=len(entries),code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),oracle_script_sha256=sha(Path(__file__).read_bytes()),
        corpus_records=13,corpus_scenes=13,corpus_object_bytes_compared=corpus_bytes_compared,
        synthetic_records=len(fixtures)+1,synthetic_calls=2*len(fixtures)+1,
        original_calls=machine.constructor_calls,loader_or_arm_calls=machine.loader_calls,direct_calls=machine.direct_calls,
        mismatches=0,native_object_sha256=native_hash.hexdigest(),original_object_sha256=original_hash.hexdigest(),
        synthetic_object_sha256=synthetic_hash.hexdigest(),synthetic_object_bytes_compared=synthetic_bytes_compared,
        corpus_bodies_sha256=bodies.hexdigest(),corpus_tails_sha256=tails.hexdigest(),resolved_visible_length_distribution=dict(resolved_lengths),
        table_allocation_calls=machine.table_allocation_calls,synthetic=synthetic,
        hooks=[dict(kind='replacement',address=hex(ALLOCATOR_VA),purpose='malloc only: bounded storage; original requested size executes'),
            dict(kind='observation',range='0x24000000..0x2401ffff',purpose='input reads inside exact ACT, writes only original inline +0x12b word'),
            dict(kind='observation',range='0x26000000..0x26009d8e',purpose='object writes inside actual allocation')],
        original_decisions_replaced=False,stop_boundaries=[hex(BOUNDARY),hex(RETURN_VA)],
        deliberate_safety_rejections=['negative inline counts, zero/unterminated inline text, inline option02>2',
            'unterminated keyed field; missing/unterminated/embedded-NUL resolved span; resolved visible length>40000',
            'short bodies, fractional dependency tails, null/wrapped/overlapping spans, zero handle, insufficient capacity'],
        unverified=['allocation failure/fatal diagnostics and nonzero logging flag','missing AUTOTEXT-key error path',
            'negative/zero inline count original behavior and unbounded original string scans',
            'generic dependency construction/evaluation','runtime type conversion to0x36 at0x411f24',
            'rendering/host effects at0x413187 and0x48945b','subtype lifecycle/rearm','whole-file matching and native gameplay'],
        elapsed_seconds=round(time.monotonic()-started,3))
    with result_path.open('x') as out: out.write(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status='pass',corpus_records=13,original_calls=machine.constructor_calls,
        object_bytes_compared=corpus_bytes_compared+synthetic_bytes_compared,mismatches=0,receipt=str(result_path),receipt_sha256=sha(result_path.read_bytes()))))

if __name__=='__main__': main()
