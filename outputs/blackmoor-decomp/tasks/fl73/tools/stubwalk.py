#!/usr/bin/env python3
"""FL-73: greedy walk over callee returns. Start from a parent scenario, try every callee (newest first) with eax in VALUES, keep the first change that adds coverage, repeat.
  stubwalk.py ROW OUT [--scen FILE ...] [--init FILE] [--seconds N] [--limit N]
The base overrides come from `--init` (a python expr: list of [addr,size,val], e.g. STUB_WR cells) or default to all callees returning 1.
"""
import sys,time,json,argparse
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
ap=argparse.ArgumentParser(); ap.add_argument('row'); ap.add_argument('out'); ap.add_argument('--scen',action='append',default=[]); ap.add_argument('--init',default=None)
ap.add_argument('--seconds',type=int,default=600); ap.add_argument('--limit',type=int,default=500000); ap.add_argument('--seed',type=int,default=1)
a=ap.parse_args()
key=a.row
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=a.limit
VALUES=(0,1,2,0xffffffff)
ex=set();ed=set();corpus=[]
def runq(s,ov):
    try: return run(W,row,s,ov)
    except Exception: return None
def offer(s,ov,tr):
    global ex,ed
    if tr is None or tr.fault or (tr.executed<=ex and tr.edges<=ed): return False
    ex|=tr.executed;ed|=tr.edges;corpus.append([s,ov]);return True
if a.scen:
    for s,ov in F.known_scenarios(key,F.POOLS[pool]['world'],a.scen):
        offer(s,[list(o) for o in ov],runq(s,ov))
init=eval(open(a.init).read()) if a.init else []
base=[list(o) for o in init]+[[W.STUB_OVR+16*k,4,1] for k in range(500)]
cur=(a.seed,base)
tr=runq(*cur); offer(*cur,tr)
print('start',cov(G,row,ex,ed)[:4],flush=True)
t0=time.time()
done=set()
progress=True
while progress and time.time()-t0<a.seconds:
    progress=False
    for idx in range(len(corpus)-1,-1,-1):
        if idx in done: continue
        done.add(idx)
        s,ov=corpus[idx]
        tr=runq(s,ov)
        if tr is None: continue
        n=len(tr.calls)
        for k in range(n-1,max(-1,n-60),-1):
            for v in VALUES:
                if any(o[0]==W.STUB_OVR+16*k and o[2]==v for o in ov): continue
                nov=[o for o in ov if o[0]!=W.STUB_OVR+16*k]+[[W.STUB_OVR+16*k,4,v]]
                t=runq(s,nov)
                if t is None or t.fault: continue
                if offer(s,nov,t):
                    progress=True
                    print('parent %d k=%d v=%d'%(idx,k,v),cov(G,row,ex,ed)[:4],len(corpus),'%.0fs'%(time.time()-t0),flush=True)
            if time.time()-t0>a.seconds: break
        if time.time()-t0>a.seconds: break
json.dump({key:corpus},open(a.out,'w'))
print('final',cov(G,row,ex,ed)[:4],len(corpus))
