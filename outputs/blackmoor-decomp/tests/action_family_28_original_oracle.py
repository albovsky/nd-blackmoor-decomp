#!/usr/bin/env python3
"""Pinned A-28 constructor/dispatcher and original x87 LUT code-window oracle.

Original dispatcher/handler/helper run unchanged. Hooks control allocation and
one dependency-result leaf only. The LUT window 447870..447920 executes its real
x87 arithmetic and __ftol, without calling DirectDraw. Capture/curve/playback
and nonempty recursive dependency reset are outside this comparison.
"""
import argparse
import ctypes as c
import hashlib
import json
import math
from pathlib import Path
import random
import struct
from cif_original_oracle import PEImage, EXPECTED_EXE_SHA256, align_up
from test_action_family_28 import Input, World, Rect, Result, Decoded, configure, buffer, payload, LIBRARY
from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE
from unicorn.x86_const import UC_X86_REG_EAX, UC_X86_REG_EBP, UC_X86_REG_ECX, UC_X86_REG_EFLAGS, UC_X86_REG_EIP, UC_X86_REG_ESP, UC_X86_REG_FPCW
ROOT=Path(__file__).resolve().parents[3]
STACK=0x10000000; TOP=STACK+0x1f000; DATA=0x20000000; END=0x30000000
EFFECT=0x6198d7
CODE_WINDOWS=[(0x4471ca,0x44727a),(0x44727a,0x4473be),(0x427eed,0x427f27),(0x447870,0x447920),(0x50ce04,0x50ce2b),(0x42ba3a,0x42babf)]
def sha(b):return hashlib.sha256(b).hexdigest()
def read32(u,a): return struct.unpack('<I',u.mem_read(a,4))[0]
def rect_values(r):return [r.left,r.top,r.right,r.bottom]
def view_world(w):
    return {'busy':w.busy,'canvas':rect_values(w.full_canvas),'rect':rect_values(w.current_rect),
            'counter':w.sequence_counter,'payload':bytes(w.active_payload).hex()}
class Original:
    def __init__(self,pe):
        self.uc=Uc(UC_ARCH_X86,UC_MODE_32);self.pe=pe
        self.uc.mem_map(pe.image_base,align_up(pe.size_of_image));self.uc.mem_write(pe.image_base,pe.image)
        self.uc.mem_map(STACK,0x20000);self.uc.mem_map(DATA,0x10000);self.uc.mem_map(END,0x1000)
        self.gate=True;self.gate_calls=0;self.alloc_calls=0
        self.uc.hook_add(UC_HOOK_CODE,self.hook,begin=0x423f57,end=0x423f57)
        self.uc.hook_add(UC_HOOK_CODE,self.hook,begin=0x51dc43,end=0x51dc43)
    def hook(self,u,addr,size,user):
        esp=u.reg_read(UC_X86_REG_ESP)
        if addr==0x51dc43:
            if read32(u,esp+4)!=21:raise RuntimeError('unexpected constructor allocation')
            self.alloc_calls+=1;u.reg_write(UC_X86_REG_EAX,DATA+0x8000);pop=0
        else:
            self.gate_calls+=1;u.reg_write(UC_X86_REG_EAX,int(self.gate));pop=4
        u.reg_write(UC_X86_REG_EIP,read32(u,esp));u.reg_write(UC_X86_REG_ESP,esp+4+pop)
    def call(self,va,args=(),ecx=0):
        esp=TOP-4*(1+len(args));self.uc.mem_write(esp,struct.pack('<'+'I'*(1+len(args)),END,*args))
        self.uc.reg_write(UC_X86_REG_ESP,esp);self.uc.reg_write(UC_X86_REG_EBP,0)
        self.uc.reg_write(UC_X86_REG_ECX,ecx);self.uc.reg_write(UC_X86_REG_EFLAGS,0x202)
        self.uc.emu_start(va,END,timeout=10000000,count=1000000)
        if self.uc.reg_read(UC_X86_REG_EIP)!=END:raise RuntimeError('original call did not return')
    def construct(self,raw):
        u=self.uc;start=DATA+0x1001;self.alloc_calls=0
        u.mem_write(0x63a4cd,b'\0\0');u.mem_write(start,raw)
        u.mem_write(DATA+0x100,struct.pack('<III',0,start,7))
        self.call(0x4471ca,(DATA+0x100,DATA+0x104,DATA+0x108))
        if self.alloc_calls!=1:raise RuntimeError('allocation hook count')
        return {'body':bytes(u.mem_read(read32(u,DATA+0x100),21)).hex(),
                'consumed':read32(u,DATA+0x108)-7,'cursor_delta':read32(u,DATA+0x104)-start}
    def dispatch(self,case):
        u=self.uc;self.gate=bool(case.get('eligible',1));self.gate_calls=0
        raw=bytes.fromhex(case['body']);busy=case.get('busy',0);phase=case.get('phase',0)
        completed=case.get('completed',0);sub=case.get('subtype',1)
        u.mem_write(0x5bb5e3,bytes([0x28,sub])+struct.pack('<I',DATA+0x1000))
        u.mem_write(DATA+0x1000,raw);u.mem_write(0x5bb625,bytes([completed]))
        u.mem_write(0x5bb632,struct.pack('<I',phase));u.mem_write(0x5bb638,bytes(4))
        u.mem_write(0x5bb5e9,bytes(0x38));u.mem_write(0x5c39e3,struct.pack('<h',1))
        u.mem_write(0x583999,struct.pack('<I',3));u.mem_write(0x63a4cd,bytes(2))
        u.mem_write(0x583186,struct.pack('<4i',10,20,629,384))
        u.mem_write(EFFECT,bytes(0x100));u.mem_write(EFFECT+0x1c,bytes([busy]))
        u.mem_write(EFFECT+0x1d,struct.pack('<4i',100,200,300,400))
        u.mem_write(EFFECT+0x2d,struct.pack('<I',123));u.mem_write(EFFECT+0x49,b'z'*21)
        self.call(0x427a50)
        return {'world':{'busy':u.mem_read(EFFECT+0x1c,1)[0],'canvas':[10,20,629,384],
            'rect':list(struct.unpack('<4i',u.mem_read(EFFECT+0x1d,16))),
            'counter':read32(u,EFFECT+0x2d),'payload':bytes(u.mem_read(EFFECT+0x49,21)).hex()},
            'phase':read32(u,0x5bb632),'completed':u.mem_read(0x5bb625,1)[0]}
    def table(self,weight):
        u=self.uc;ebp=TOP-0x1000
        u.reg_write(UC_X86_REG_EBP,ebp);u.reg_write(UC_X86_REG_ESP,ebp-0x6000)
        u.reg_write(UC_X86_REG_FPCW,0x037f);u.mem_write(ebp+0x14,struct.pack('<d',weight))
        u.emu_start(0x447870,0x447920,timeout=10000000,count=500000)
        if u.reg_read(UC_X86_REG_EIP)!=0x447920:raise RuntimeError('LUT window did not finish')
        return list(struct.unpack('<4096i',u.mem_read(ebp-0x4084,4096*4)))
def native_dispatch(lib,case):
    raw=buffer(bytes.fromhex(case['body']));eligible=case.get('eligible',1) and not case.get('completed',0)
    a=Input(0x28,case.get('subtype',1),int(eligible),case.get('completed',0),case.get('phase',0),raw,21)
    w=World(case.get('busy',0),Rect(10,20,629,384),Rect(100,200,300,400),123);w.active_payload[:]=b'z'*21;r=Result()
    if lib.action_family28_step(c.byref(a),c.byref(w),c.byref(r)):raise RuntimeError('native step rejected fixture')
    return {'world':view_world(r.world),'phase':r.phase,'completed':r.completed if r.completion_valid else a.completed_before}
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--original-only',action='store_true');args=ap.parse_args()
    pe=PEImage.parse_and_map(ROOT/'work/original/GAME.EXE')
    if sha(pe.data)!=EXPECTED_EXE_SHA256:raise RuntimeError('unpinned executable')
    original=Original(pe);lib=None if args.original_only else configure(c.CDLL(str(LIBRARY)))
    corpus=json.loads((ROOT/'work/analysis/slices/A-28-corpus.json').read_text());cases=[];constructs=[];mismatches=[]
    for row in corpus:
        label=f"{row['scene']}:{row['action']}";raw=bytes.fromhex(row['body_hex']);o=original.construct(raw);constructs.append(o)
        if o!={'body':raw[:21].hex(),'consumed':21,'cursor_delta':21}:raise RuntimeError('constructor boundary mismatch '+label)
        if lib:
            d=Decoded();n=c.c_size_t()
            if lib.action_family28_decode(buffer(raw),len(raw),c.byref(d),c.byref(n)) or n.value!=21 or bytes(d.source_bytes)!=raw[:21]:mismatches.append(label+':decode')
        cases.append({'label':label,'body':raw[:21].hex(),'subtype':row['subtype']})
    for phase in [0,1,2,3]:
        for subtype in [0,1,2,7]:cases.append({'label':f'phase{phase}-sub{subtype}','body':payload(rect=(2,3,8,9)).hex(),'phase':phase,'subtype':subtype})
    cases += [{'label':'busy','body':payload().hex(),'busy':1},
        {'label':'false-gate','body':payload().hex(),'eligible':0,'phase':2},
        {'label':'completed-skip','body':payload().hex(),'completed':1,'phase':2},
        {'label':'rect-wrap','body':payload(rect=(0x7fffffff,0x7fffffff,0x7ffffffe,0x7ffffffd)).hex()}]
    dispatch_hash=hashlib.sha256()
    for case in cases:
        out=original.dispatch(case);dispatch_hash.update(json.dumps(out,sort_keys=True).encode())
        if lib and native_dispatch(lib,case)!=out:mismatches.append(case['label']+':dispatch')
    rng=random.Random(28)
    weights=[0.,1.,.5,.25,.75,.125,.001,.999,math.nextafter(.5,0),math.nextafter(.5,1),math.nextafter(.25,0),math.nextafter(.25,1)]+[rng.random() for _ in range(12)]
    lut_hashes=[]
    for w in weights:
        out=original.table(w);lut_hashes.append(sha(struct.pack('<4096i',*out)))
        if lib:
            native=(c.c_int32*4096)()
            if lib.action_family28_blend_table(w,native,4096) or list(native)!=out:mismatches.append(f'LUT:{w.hex()}')
    report={'executable_sha256':sha(pe.data),'corpus_records':len(corpus),'constructor_calls':len(constructs),
        'dispatcher_calls':len(cases),'lut_weight_cases':len(weights),'lut_entries':len(weights)*4096,
        'native_compared':bool(lib),'mismatches':mismatches,'dispatcher_result_hash':dispatch_hash.hexdigest(),
        'lut_hashes':lut_hashes,'weights':[w.hex() for w in weights],
        'code_windows':[{'start':hex(a),'end':hex(b),'sha256':sha(pe.image[a-pe.image_base:b-pe.image_base])} for a,b in CODE_WINDOWS],
        'hooks':['0x51dc43 allocation (21 bytes)','0x423f57 dependency-result leaf'],
        'excluded':['framebuffer capture','blend curve and timing controller','audio pumping','DirectDraw presentation','nonempty recursive dependency reset','allocator failure dialog','original program x87 control word']}
    name='A-28-original-only.json' if args.original_only else 'A-28-original-oracle.json'
    (ROOT/'work/analysis/slices'/name).write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k] for k in ['constructor_calls','dispatcher_calls','lut_entries','native_compared','mismatches']}))
    if mismatches:raise SystemExit(1)
if __name__=='__main__':main()
