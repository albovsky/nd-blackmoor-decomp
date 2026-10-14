#!/usr/bin/env python3
"""A-36.1 immutable x86 loader/constructor and dependency-boundary oracle.

Run with work/tools/oracle-python/bin/python and Unicorn JIT permitted.
Only successful malloc is replaced. No original decision is replaced.
Each report uses a new private path; proprietary fixture bytes stay local.
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
from test_action_family_36 import (Decoded, Constructed, OBJECT_BYTES, PREFIX,
    body_fixture, load_native, pointer, storage, narrow, OK, BODY, TAIL, COUNT)

ROOT = Path(__file__).resolve().parents[3]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MANIFEST_HASH = '440495d49bd047bff32822234dd874b0344610641e0daf053ebfb3ace97c212c'
ARCHIVE_HASH = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
CORPUS_HASH = '1177233aad4c5e32a318a1c9d2377c2bad948f016963dca89a73926a24ca4164'
CODE = [(4240202, 4240646, '814e17870c4e2e5af99131fe89ca1285f973a76cd73ca1ded805ac57f0142dbc'), (4263076, 4263817, 'f0f3d9d13f29235857de8668074c958d1b972815091fad8ebb89eca87ff14620'), (4244438, 4244484, '3cd8a8ce48a44f9fb1936b01e284ccc28d6c3e09e42284aeae9236de10fcc6d9'), (4755100, 4755547, 'f2ca65102b72b407f020982400f4a39a1b891ad199d0947ec840b7ce76dbc0e1'), (4262504, 4262570, 'b44affd77cc78341b7821363928d6d5ff00aa5ed0fa8c092e61bfffcbad6373d'), (4344488, 4344987, 'c866f93b60ce24718453fa18b70348c779e3b8882f0a4f211fe4954450d4ddfc'), (4358275, 4358334, '5e56dabcd602aa146d0b1874b5c784ef43f9f36dc5a97c29559828857f45131a')]
INPUT, DATA, STACK = 0x20000000, 0x30000000, 0x5800
OWNER, SLOT, CURSOR, OFFSET, OUT = (DATA+x for x in (0x1000,0x2000,0x2400,0x2404,0x5000))
STOP, ALLOCATOR, DEPENDENCY_BOUNDARY = 0x51000000, 0x51dc43, 0x410a68
TAIL_STOPS = (0x424c31,0x424c5b,0x424c94)
HOOKS = [
    {'address':'0x51dc43','kind':'replacement','scope':'cdecl malloc; return seeded 0xaba allocation; successful path only'},
    {'range':'input mapping','kind':'observation','scope':'assert original reads stay in exact supplied input'},
    {'range':'allocation plus redzones','kind':'observation','scope':'assert original writes stay in 0xaba allocation'},
    {'addresses':[hex(v) for v in TAIL_STOPS],'kind':'stop','scope':'observe unchanged dependency empty/reject/accept branches before diagnostics or row processing'},
]

class OracleError(RuntimeError):
    pass


def sha(data):
    return hashlib.sha256(data).hexdigest()


def require(condition,message):
    if not condition:
        raise OracleError(message)


class Original:
    def __init__(self, pe):
        from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
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
        self.source_span=(0,0)
        self.tail_exit=None
        self.dependency_calls=0
        self.allocations=0
        self.sizes=Counter()
        self.seed=bytes([0xCD])*OBJECT_BYTES
        self.uc.hook_add(UC_HOOK_CODE,self.allocate,begin=ALLOCATOR,end=ALLOCATOR)
        self.uc.hook_add(UC_HOOK_MEM_READ,self.observe_read,begin=INPUT,end=INPUT+0x1ffff)
        self.uc.hook_add(UC_HOOK_MEM_WRITE,self.observe_write,begin=OUT-16,end=OUT+OBJECT_BYTES+15)
        self.uc.hook_add(UC_HOOK_CODE,self.stop_tail,begin=0x424c31,end=0x424c94)

    def observe_read(self,_uc,_access,address,size,_value,_data):
        if address < self.source_span[0] or address+size > self.source_span[1]:
            raise OracleError('original read outside exact fixture')

    def observe_write(self,_uc,_access,address,size,_value,_data):
        if address < OUT or address+size > OUT+OBJECT_BYTES:
            raise OracleError('original write outside allocation')

    def stop_tail(self,uc,address,_size,_data):
        if address in TAIL_STOPS:
            self.tail_exit=address
            uc.emu_stop()

    def dependency(self,body,advance):
        uc,r=self.uc,self.r
        slot=SLOT
        uc.mem_write(slot,bytes(0x8d))  # fresh caller-owned action slot
        uc.mem_write(0x63786d+0x60c,bytes(4))  # fresh caller dependency state
        args=struct.pack('<5I',STOP,slot,50+advance,50+len(body),INPUT+16+50+advance)
        uc.mem_write(STACK,args)
        uc.reg_write(r['ESP'],STACK)
        uc.reg_write(r['ECX'],0x63786d)
        uc.reg_write(r['EFLAGS'],0x202)
        self.tail_exit=None
        uc.emu_start(0x424aa8,STOP,count=100000)
        if self.tail_exit not in TAIL_STOPS:
            raise OracleError('original dependency outcome not reached')
        count=struct.unpack('<I',uc.mem_read(slot+0x36+0x34,4))[0]
        self.dependency_calls+=1
        return self.tail_exit != 0x424c5b,count,self.tail_exit


    def allocate(self,uc,address,_size,_data):
        if address!=ALLOCATOR:
            raise OracleError('unexpected hook')
        esp=uc.reg_read(self.r['ESP'])
        ret,n=struct.unpack('<II',uc.mem_read(esp,8))
        if n!=OBJECT_BYTES:
            raise OracleError(f'unexpected allocation size {n}')
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
            raise OracleError('invalid allocation seed')
        loader=payload is not None
        source=payload if loader else bytes(50)+body
        if len(source)+32 > 0x20000:
            raise OracleError('fixture exceeds oracle mapping')
        self.source_span=(INPUT+16,INPUT+16+len(source))
        body_va=INPUT+16+50
        uc.mem_write(INPUT,b'\xa6'*16+source+b'\xd6'*16)
        owner=0x619935 if loader else OWNER
        slot=0x5bb5e5 if loader else SLOT
        owner_before=b'\x5a'*0x100
        uc.mem_write(owner-16,b'\x91'*16+owner_before+b'\x92'*16)
        if bytes(uc.mem_read(0x63a4cd,2))!=bytes(2):
            raise OracleError('pinned original diagnostic flag is nonzero')
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
        entry,boundary=(0x40b34a,DEPENDENCY_BOUNDARY) if loader else (0x488e9c,STOP)
        before=self.allocations
        uc.emu_start(entry,boundary,count=1000000)
        if uc.reg_read(r['EIP'])!=boundary or self.allocations!=before+1:
            raise OracleError('original did not reach boundary with one allocation')
        if loader:
            ebp=uc.reg_read(r['EBP'])
            cursor=struct.unpack('<I',uc.mem_read(ebp-0x20,4))[0]
            offset=struct.unpack('<I',uc.mem_read(ebp-0xcc,4))[0]
            expected=bytearray(0x8d)
            name_size=payload.index(0,0,48)+1
            expected[:name_size]=payload[:name_size]
            expected[48:50]=bytes([0x36,payload[49]])
            expected[50:54]=struct.pack('<I',OUT)
            if bytes(uc.mem_read(0x5bb5b3,0x8d))!=bytes(expected):
                raise OracleError('original runtime normalization/subtype mismatch')
        else:
            cursor,offset=struct.unpack('<II',uc.mem_read(CURSOR,8))
            if uc.reg_read(r['ESP'])!=STACK+16:
                raise OracleError('constructor RET cleanup mismatch')
            for name in ('EBX','ESI','EDI','EBP'):
                if uc.reg_read(r[name])!=initial[name]:
                    raise OracleError('constructor changed callee-saved register')
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
                raise OracleError(f'original source/owner/slot/stack/allocation guard changed at {address:#x}')
        if struct.unpack('<I',uc.mem_read(slot,4))[0]!=OUT:
            raise OracleError('original result slot did not receive allocation')
        return bytes(uc.mem_read(OUT,OBJECT_BYTES)),cursor-body_va,offset


def compare(lib, machine, body, seed, ordinal, payload=None, offset=50):
    # Execute original first, including the genuine dependency-size decision.
    original, advance, after = machine.invoke(body, seed, payload, offset)
    accepted, original_count, exit_address = machine.dependency(body, advance)
    raw, allocation = storage(body), storage(seed)
    d, native, body_length = Decoded(), Constructed(), C.c_size_t(0xa5a5)
    C.memset(C.byref(d), 0xa5, C.sizeof(d))
    C.memset(C.byref(native), 0xa5, C.sizeof(native))
    before_d, before_native, before_length = bytes(d), bytes(native), body_length.value
    statuses = (lib.action_family_36_decode(raw, len(body), C.byref(d)),
        lib.action_family_36_construct(raw, len(body), allocation, len(allocation), offset, OUT, C.byref(native)),
        lib.action_family_36_body_length(raw, len(body), C.byref(body_length)))
    require(statuses == (OK if accepted else TAIL,) * 3,
            f'original/native dependency acceptance mismatch record {ordinal}: {statuses}')
    require(after == (offset + advance) & 0xffffffff, 'original cursor addition mismatch')
    if not accepted:
        require((bytes(d), bytes(native), body_length.value) == (before_d, before_native, before_length),
                'native rejected tail mutated output')
        require(bytes(raw) == body and bytes(allocation) == seed, 'native rejected tail mutated input')
        return b'', original, exit_address
    require(body_length.value == advance, f'original/native body_length mismatch record {ordinal}')
    mode = struct.unpack_from('<H', body, 0x29)[0]
    direct = struct.unpack_from('<h', body, 0x2b)[0]
    start, end = struct.unpack_from('<hh', body, 0x33)
    secondary = struct.unpack_from('<h', body, 0xaa)[0]
    primary = narrow(end - start + 1) if mode == 2 else direct
    require(bytes(d.prefix_bytes) == body[:PREFIX] and
        (d.option_29,d.word_2b,d.word_33,d.word_35,d.word_aa) == (mode,direct,start,end,secondary),
        f'decoded neutral fields mismatch record {ordinal}')
    require((pointer(d.primary_records),d.primary_count,pointer(d.secondary_records),d.secondary_count,
             pointer(d.dependency_records),d.dependency_count,d.body_bytes,d.dependency_bytes,d.available_body_bytes) ==
        (C.addressof(raw)+PREFIX,primary,C.addressof(raw)+PREFIX+primary*16,secondary,
         C.addressof(raw)+advance,original_count,advance,len(body)-advance,len(body)),
        f'decoded body/tail/count mismatch record {ordinal}')
    require(bytes(native.object_bytes) == original, f'original/native object mismatch record {ordinal}')
    require((native.body_bytes_consumed,native.payload_offset_before,native.payload_offset_after,
        pointer(native.dependency_records),native.dependency_count,native.dependency_bytes,native.available_body_bytes) ==
        (advance,offset,after,C.addressof(raw)+advance,original_count,len(body)-advance,len(body)),
        f'original/native cursor/tail/count mismatch record {ordinal}')
    links = native.owner_links
    require((links.output_handle,links.result_slot_handle,links.owner_slot_1c_handle,
             links.owner_slot_20_handle,links.output_allocation_bytes) == (OUT,OUT,OUT,OUT,OBJECT_BYTES),
            f'original/native owner/constants mismatch record {ordinal}')
    require(bytes(raw) == body and bytes(allocation) == seed, 'native mutated an input')
    return bytes(native.object_bytes), original, exit_address


def safety_checks(lib, machine):
    calls = 0
    seed = storage(bytes(OBJECT_BYTES))
    cases = [(body_fixture(0,0)[:n],BODY) for n in range(PREFIX)]
    # A truncated primary or secondary table, every possible cut position.
    data = body_fixture(4,3)
    cases += [(data[:n],BODY) for n in range(PREFIX,len(data))]
    cases += [(body_fixture(p,0),COUNT) for p in (-32768,-1,101,32767)]
    cases += [(body_fixture(0,s),COUNT) for s in (-32768,-1,26,32767)]
    for body, expected in cases:
        raw, d, c, n = storage(body), Decoded(), Constructed(), C.c_size_t(123456)
        C.memset(C.byref(d),0xa5,C.sizeof(d)); C.memset(C.byref(c),0xa5,C.sizeof(c))
        before = (bytes(d),bytes(c),n.value)
        statuses = (lib.action_family_36_decode(raw,len(body),C.byref(d)),
            lib.action_family_36_body_length(raw,len(body),C.byref(n)),
            lib.action_family_36_construct(raw,len(body),seed,OBJECT_BYTES,50,OUT,C.byref(c)))
        require(statuses == (expected,)*3, 'native short/count safety mismatch')
        require((bytes(d),bytes(c),n.value) == before and bytes(raw) == body,
                'native safety rejection mutated storage')
        calls += 1
    # Demonstrate why truncated original input is not a parity domain: the
    # unchanged REP copy reads outside the supplied prefix/table. No returned
    # original status is invented and no original decision is hooked.
    probes = [body_fixture(0,0)[:171],body_fixture(1,0)[:-1],body_fixture(0,1)[:-1]]
    observed = 0
    for body in probes:
        try:
            machine.invoke(body, bytes(OBJECT_BYTES))
        except OracleError as error:
            require(str(error) == 'original read outside exact fixture', 'unexpected short-original probe failure')
            observed += 1
        else:
            raise OracleError('short-original probe did not expose unsafe read')
    return calls, observed


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--native-library',type=Path,default=ROOT/'outputs/blackmoor-decomp/build/libactionfamily36.dylib')
    ap.add_argument('--result',type=Path)
    args = ap.parse_args()
    result_path = args.result or Path(tempfile.mkdtemp(prefix='A-36.1.oracle-',dir=PRIVATE))/'report.json'
    require(not result_path.exists(),'result path must be unique')
    started = time.monotonic()
    mb = (ROOT/'work/analysis/hiff-resources.json').read_bytes()
    cb = (PRIVATE/'A-36.1.corpus.json').read_bytes()
    require((sha(mb),sha(cb)) == (MANIFEST_HASH,CORPUS_HASH),'manifest/corpus identity mismatch')
    manifest, corpus = json.loads(mb),json.loads(cb)
    require((manifest['archive_sha256'],corpus['archive_sha256'],corpus['exe_sha256'],
        corpus['manifest_sha256'],corpus['raw_0x36_records'],len(corpus['records']),
        corpus['scen_data_records'],corpus['scene_actions']) ==
        (ARCHIVE_HASH,ARCHIVE_HASH,EXE_HASH,MANIFEST_HASH,20,20,2078,19612),'corpus count mismatch')
    resources = {}
    for row in manifest['resources']:
        index = int(row['index'])
        data = (ROOT/'work/analysis/hiff-resources'/f'{index:04d}.bin').read_bytes()
        require((len(data),sha(data)) == (row['size'],row['sha256']),f'resource identity mismatch {index}')
        resources[index] = data
    require(len(resources) == 2267,'resource count mismatch')
    pe = PEImage.parse_and_map(ROOT/'work/original/GAME.EXE')
    require(sha(pe.data) == EXE_HASH and len(pe.data) == 1511424,'original executable mismatch')
    for a,b,digest in CODE:
        require(sha(pe.image[a-pe.image_base:b-pe.image_base]) == digest,f'code range mismatch {a:#x}')
    lib, machine = load_native(args.native_library), Original(pe)
    native_hash, original_hash, body_hash, tail_hash = [hashlib.sha256() for _ in range(4)]
    outcomes = Counter()
    for ordinal,row in enumerate(corpus['records']):
        data = resources[row['resource_index']]
        p,n = row['act_payload_offset'],row['act_payload_length']
        payload = data[p:p+n]; body = payload[50:]; typed = row['typed_body_length']
        require((row['raw_body_offset'],len(body),sha(body),payload[48],payload[49],
                 sha(body[:typed]),sha(body[typed:])) ==
                (p+50,row['raw_body_length'],row['body_sha256'],0x36,row['subtype'],
                 row['typed_body_sha256'],row['dependency_tail_sha256']),f'corpus row mismatch {ordinal}')
        seed = bytes((i*29+ordinal*31+7)&255 for i in range(OBJECT_BYTES))
        native, original, outcome = compare(lib,machine,body,seed,ordinal,payload)
        native_hash.update(native);original_hash.update(original);body_hash.update(body);tail_hash.update(body[typed:])
        outcomes[hex(outcome)] += 1
    corpus_calls = machine.allocations
    synthetic_hash = hashlib.sha256(); synthetic_calls = 0
    # Both branches, all safe table boundaries, signed-looking options,
    # discarded direct counts, signed endpoints and narrowing wrap examples.
    fixtures = [body_fixture(p,s,mode=m,tail=t) for p,s in ((0,0),(1,1),(100,25),(100,0),(0,25))
                for m in (0,1,2,3,0x8000,0xffff) for t in (0,1,2)]
    fixtures += [body_fixture(-1,1,mode=2,start=a,end=b) for a,b in
                 ((-32768,32767),(32767,-32768),(-32768,-32669),(0,-1))]
    for ordinal,body in enumerate(fixtures):
        for loader in (True,False):
            subtype = ordinal & 255
            payload = b'synthetic'+bytes(39)+bytes([0x36,subtype])+body if loader else None
            offset = 50 if loader else (0,50,0xfffffffe,0xffffffff)[ordinal%4]
            seed = bytes((i*17+ordinal*19+11)&255 for i in range(OBJECT_BYTES))
            native,original,outcome = compare(lib,machine,body,seed,f'synthetic-{ordinal}-{loader}',payload,offset)
            synthetic_hash.update(native);outcomes[hex(outcome)] += 1; synthetic_calls += 1
    for subtype in range(256):
        body = body_fixture(subtype % 101, subtype % 26, mode=subtype % 4, tail=subtype % 3)
        payload = b'subtype'+bytes(41)+bytes([0x36,subtype])+body
        seed = bytes((i*31+subtype)&255 for i in range(OBJECT_BYTES))
        native,original,outcome = compare(lib,machine,body,seed,f'subtype-{subtype}',payload)
        synthetic_hash.update(native);outcomes[hex(outcome)] += 1;synthetic_calls += 1
    # Original generic dependency loader runs for every synthetic length,
    # including fractional tails. Native invalid results must be atomic.
    tail_cases = 0
    for length in range(41):
        body = body_fixture(2,1) + bytes((i*13+7)&255 for i in range(length))
        seed = bytes((i*19+length)&255 for i in range(OBJECT_BYTES))
        native,original,outcome = compare(lib,machine,body,seed,f'tail-{length}')
        outcomes[hex(outcome)] += 1;tail_cases += 1
    safety_cases,short_probes = safety_checks(lib,machine)
    result = dict(slice='A-36.1',scope='original loader/constructor and dependency-size decisions; runtime excluded',
        inputs=dict(exe_sha256=EXE_HASH,manifest_sha256=MANIFEST_HASH,archive_sha256=ARCHIVE_HASH,
            corpus_sha256=CORPUS_HASH,resources_verified=len(resources),code_windows=CODE),
        native_library_sha256=sha(args.native_library.read_bytes()),oracle_script_sha256=sha(Path(__file__).read_bytes()),
        corpus_records=20,corpus_original_calls=corpus_calls,synthetic_original_calls=synthetic_calls,
        synthetic_tail_cases=tail_cases,dependency_original_calls=machine.dependency_calls,
        dependency_stop_counts=dict(outcomes),completed_constructor_calls=corpus_calls+synthetic_calls+tail_cases,
        allocations_including_short_probes=machine.allocations,short_original_unsafe_read_probes=short_probes,
        native_safety_rejection_cases=safety_cases,mismatches=0,
        corpus_object_bytes_compared=20*OBJECT_BYTES,synthetic_object_bytes_compared=synthetic_calls*OBJECT_BYTES,
        corpus_object_sha256=native_hash.hexdigest(),original_object_sha256=original_hash.hexdigest(),
        synthetic_object_sha256=synthetic_hash.hexdigest(),corpus_raw_bodies_sha256=body_hash.hexdigest(),
        corpus_dependency_tails_sha256=tail_hash.hexdigest(),allocation_sizes=dict(machine.sizes),hooks=HOOKS,
        deliberate_safety_rejections=['negative/over-capacity primary and secondary counts; original unchecked copies',
            'short bodies; original overreads demonstrated separately',
            'null, address wrap, overlap, wrong allocation size and zero handle; native API contracts'],
        unverified=['malloc failure/fatal cleanup','nonzero diagnostics','prior action slot reuse',
            'dependency row construction and evaluation after size accept','runtime/lifecycle/render/host effects',
            'subtype gameplay; corpus subtype is only 1','whole-file matching and native gameplay'],
        elapsed_seconds=round(time.monotonic()-started,3))
    with result_path.open('x') as output:
        output.write(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('corpus_records','synthetic_original_calls','synthetic_tail_cases',
        'dependency_original_calls','native_safety_rejection_cases','mismatches')} | {'result':str(result_path)}))


if __name__ == '__main__':
    main()
