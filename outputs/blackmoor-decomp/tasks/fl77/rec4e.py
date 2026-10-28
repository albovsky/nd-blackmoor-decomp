"""rec4e.py OUT SEEDS(a-b) TLO-THI : state-2 scenarios of 0x4e4cb6 with deterministic slot t: ret 0 on every earlier 0x4e4ece hit, ret 1 on hit t; cells from CFGS (env CFGS python list of lists of (path,size,val) relative to ecx at entry)."""
import sys, os
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl77')
from pipe import *
key='0x4e4cb6'
out=sys.argv[1]; a,b=map(int,sys.argv[2].split('-')); tlo,thi=map(int,sys.argv[3].split('-'))
cfgs=eval(os.environ['CFGS'])
pool,W,G,row=setup(key)
def hits(s,nov):
    ks=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,ad,sz,u): ks.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=0x4e4ece,end=0x4e4ece)
    try: W.run_original(row,s,[tuple(o) for o in nov],watch=watch)
    except Exception: return None
    gc.collect(); return ks
ex=set();ed=set();kept=[]
for s in range(a,b):
  for cfg in cfgs:
    base=apply_recipe(W,row,s,[],[('cellv',0x4e4cc5,'eax',0x4528,4,2),('ret',0x4e4e1d,0,1),('cells',0x4e4cb6,'ecx',[([0x6b2],2,0x270f),([0x65d2],4,0)]+list(cfg))])
    if base is None: continue
    for t in range(tlo,thi+1):
        nov=list(base); ok=False
        for it in range(6):
            ks=hits(s,nov)
            if ks is None or len(ks)<=t: break
            def setr(nov,k,v): return [o for o in nov if o[0]!=W.STUB_OVR+16*k]+[[W.STUB_OVR+16*k,4,v]]
            new=nov
            for j in range(t): new=setr(new,ks[j],0)
            new=setr(new,ks[t],1)
            if new==nov: ok=True; break
            nov=new
        if not ok: continue
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,t,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,' '.join('%x%s'%(x,'T' if n=='taken' else 'F') for x,n in untaken))
json.dump({key:kept},open(out,'w'))
