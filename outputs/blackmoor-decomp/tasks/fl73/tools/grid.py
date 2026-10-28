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
GR=0x20100000
OFFS={'0x49e455':(0xc8,0xf0,0x188),'0x49f86a':(0x118,0x140,0x186),'0x4a0365':(0xf0,0x118,0x184)}
def fresh():
    o1,o2,o3=OFFS[key]
    ov=[]
    ov.append([W.REG_OVERRIDE+4,4,THIS])
    arg=rng.choice((0,0,1))
    ov.append([SP+4,4,arg]); big=(key in ('0x4a0365','0x49e455')); lo=(4,5) if big else (1,2,3)
    ov.append([SP+8,4,rng.choice(lo)]); ov.append([SP+12,4,rng.choice(lo)])
    pm=rng.choice((0.0,0.2))
    for off in range(0,0x1000,4):
        if rng.random()<pm: ov.append([THIS+off,4,rng.choice((0,1,2,3,0xffffffff))])
    W_=rng.choice((9,10,11) if big else (4,5,6)); H_=rng.choice((9,10,11) if big else (4,5,6))
    ov+=[[THIS+0x1c,4,W_],[THIS+0x20,4,H_],[THIS+0xe38,4,GR],[THIS+0x24,4,rng.choice((1,2,3,5))],[THIS+0xe20,4,rng.choice((1,1,2))],[THIS+0xe1c,4,rng.choice((1,1,2))],[THIS+0xe2c,4,rng.choice((0x3f800000,0x40000000,0x40400000))],[THIS+0xe0c,4,rng.choice((0,1,2))]]
    base=THIS+0x2c+0x15e*arg
    allneg_flag=rng.random()<0.08
    allneg_state=True
    ov.append([0x6329d5,4,rng.choice((0,1,2,3,5,0xffffffff,0x7fffffff,0x40000000))])
    for j in range(10):
        ov.append([base+o1+4*j,4,0xffffffff if allneg_flag else rng.choice((0xffffffff,0,1,2,0x1000000,0x10000,0x100,0x10101,0x1000101,0x10100,0x1010000))])
        ov.append([base+o2+2*j,2,rng.choice((0xffff,0,1,2,3,5,0x7fff,0x20))])
    ov.append([base+o3,2,rng.choice((1,2,3))])
    for i in range(H_*W_+2):
        ov.append([GR+4*i,4,rng.choice((0,0x1000000,0x1000001)) if rng.random()<float(__import__('os').environ.get('PF','0.5')) else 0])
    if key=='0x49e455':
        for n_,po in enumerate((0xe3c,0xe40,0xe44,0xe48,0xe4c,0xe50)):
            g=0x20180000+0x10000*n_
            ov.append([THIS+po,4,g])
            for i in range(H_*W_+2):
                ov.append([g+4*i,4,rng.choice((0,0,1,5,0x1000000))])
        ov+=[[0x6329c9,4,rng.randrange(0,8)],[0x6329cd,4,rng.randrange(0,8)]]
    for k in range(60):
        ov.append([W.STUB_OVR+16*k,4,rng.choice((0,1,1,2,3,0xffffffff,0x80000001))])
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
    if corpus and rng.random()<float(__import__('os').environ.get('MUT','0.8')):
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
                gb=GR if (key!='0x49e455' or rng.random()<0.4) else 0x20180000+0x10000*rng.randrange(6); gi=gb+4*rng.randrange(0,100); ov=[o for o in ov if o[0]!=gi]+[[gi,4,rng.choice((0,0,1,5,0x1000000,0x1000001))]]
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
