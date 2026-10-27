#!/usr/bin/env python3
"""FL-73: structured coverage-guided fuzzer for the record-handler dispatchers (original bytes under Unicorn only; the translation is compared afterwards by fl66_tested.py check).

  fuzz.py ROW OUT --seconds N [--seed N] [--rec] [--scen FILE ...]

Candidates are small-valued: `this` points at a block of small words, a record of the 0x8d-byte table at 0x5bb5e3 (type, parameter pointer, state dword) points at a block of small words, the first argument is
a record index, and every callee returns 0 or 1 (STUB_OVR). A kept scenario is mutated by changing one cell it reads to a small value, by changing one stub return, or by changing the record state.
"""
import sys,random,time,json
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import fl68_search as S
ap=__import__('argparse').ArgumentParser()
ap.add_argument('row'); ap.add_argument('out'); ap.add_argument('--seconds',type=int,default=300); ap.add_argument('--seed',type=int,default=1)
ap.add_argument('--rec',action='store_true'); ap.add_argument('--scen',action='append',default=[]); ap.add_argument('--zero',action='store_true'); ap.add_argument('--limit',type=int,default=400000); ap.add_argument('--block',type=lambda x:int(x,0),default=0x1000)
a=ap.parse_args()
key=a.row
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=a.limit
rng=random.Random(a.seed)
SP=W.STACK_BASE+W.STACK_SIZE-0x100-4*(W.ARGS+1)
THIS=0x20000000; PTR=0x20010000
STUBV=(0,1,1,2,3,5,7,0x80000001,0xffffffff,0x7fffffff,100)
SMALL=(0,0,0,1,1,2,3,4,5,8,0x10,0xff,0x100,0xffff,0xffffffff)
def smallv(n): 
    v=rng.choice(SMALL)
    return v&((1<<(8*n))-1)
def fresh():
    ov=[]
    ov.append([W.REG_OVERRIDE+4,4,THIS])
    ov.append([SP+4,4,0 if a.rec else rng.choice((0,0,1,2,3))])
    if a.rec:
        t=rng.randrange(256)
        base=0x5bb5e3
        ov+=[[base,1,t],[base+2,4,PTR],[base+0x42,1,0],[base+0x4f,4,rng.choice((0,1,2))],[base+0x55,4,0]]
    pm=rng.choice((0.2,0.5,0.8))
    for blk in (THIS,PTR):
        for off in range(0,a.block,4):
            if rng.random()<pm:
                ov.append([blk+off,4,rng.choice((0,0,1,2,3,0xffffffff,0xffffffff,rng.randrange(0,0x10000),(rng.randrange(0,4)<<16)|rng.randrange(0,4)))])
    if a.zero:
        ov=[o for o in ov if not (THIS<=o[0]<THIS+0x2100)]
        for off in range(0,0x2100,4): ov.append([THIS+off,4,0])
        ov.append([THIS+0x2095,4,rng.choice((1,2,4,8,0x10,0x30))])
        objs=[PTR+0x80*i for i in range(6)]
        for o in objs: ov.append([o+0x2f,2,rng.choice((1,2,4,8,0x10,0x18))])
        ov.append([0x639895,2,rng.choice((1,2,4,0x10,0x30))])
        for base in (0x20e5,0x22d9,0x242d):
            for i in range(rng.choice((0,1,2,4,8))): ov.append([THIS+base+4*i,4,rng.choice(objs)])
        for _ in range(rng.choice((1,1,2,3,5))):
            j=rng.randrange(0,235); at=THIS+0xa0+j*0x21
            txt=bytes(rng.choice(b'abcxyz_ 0123') for _ in range(rng.randrange(1,6)))
            for i,b in enumerate(txt): ov.append([at+i,1,b])
    for k in range(60):
        ov.append([W.STUB_OVR+16*k,4,rng.choice(STUBV)])
    return ov
def key_of(ov): return tuple(sorted((o[0],o[1],o[2]) for o in ov))
ex=set();ed=set();corpus=[];seen=set()
def offer(seed,ov,tr):
    global ex,ed
    if tr.fault: return False
    if tr.executed<=ex and tr.edges<=ed: return False
    ex|=tr.executed;ed|=tr.edges;corpus.append((seed,ov));return True
scen=F.known_scenarios(key,F.POOLS[pool]['world'],a.scen) if a.scen else []
for s,ov in scen:
    tr=run(W,row,s,ov)
    offer(s,[list(o) for o in ov],tr)
print('start',cov(G,row,ex,ed)[:4],len(corpus),flush=True)
t0=time.time();runs=0;last=0
while time.time()-t0<a.seconds:
    if corpus and rng.random()<0.8:
        s,ov=rng.choice(corpus[-60:])
        ov=[list(o) for o in ov]
        for _ in range(rng.choice((1,1,2,3))):
            m=rng.random()
            if m<0.5:
                tr=run(W,row,s,ov,observe=True)
                if tr.fault: break
                cells=list(S.cells_of(W,tr).items())
                if cells:
                    (addr,n),v=rng.choice(cells)
                    ov=[o for o in ov if o[0]!=addr]+[[addr,n,smallv(n)]]
            elif m<0.75:
                k=rng.randrange(40); ov=[o for o in ov if o[0]!=W.STUB_OVR+16*k]+[[W.STUB_OVR+16*k,4,rng.choice(STUBV)]]
            elif m<0.9 and a.rec:
                ov=[o for o in ov if o[0]!=0x5bb5e3+0x4f]+[[0x5bb5e3+0x4f,4,rng.choice((0,1,2))]]
            else:
                blk=rng.choice((THIS,PTR)); off=rng.randrange(0,a.block,4)
                ov=[o for o in ov if o[0]!=blk+off]+[[blk+off,4,smallv(4)]]
    else:
        s=1;ov=fresh()
    k=key_of(ov)
    if k in seen: continue
    seen.add(k)
    tr=run(W,row,s,ov);runs+=1
    if offer(s,ov,tr):
        last=time.time()-t0
    if runs%500==0: print(runs,len(corpus),cov(G,row,ex,ed)[:4],'%.0fs'%(time.time()-t0),flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',runs,len(corpus),got,total,taken,dirs)
json.dump({key:[[s,ov] for s,ov in corpus]},open(a.out,'w'))
