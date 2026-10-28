"""stubret.py ROW OUT 'PC=v1,v2;PC=v1,..' [scen..]: for each scenario that reaches those call PCs, set the eax their stubs return (first hit of each PC) to every combination; keep coverage-adders.
env G='ADDR:size:v1,v2;..' also sweeps global cells; env REQ=pc,pc scenarios must execute those pcs; env ECX=1 sets the same values into ecx instead of eax"""
import sys,os,itertools; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn
key=sys.argv[1]; out=sys.argv[2]; spec=sys.argv[3]; extra=sys.argv[4:]
parts=[]
for p in spec.split(';'):
    pc,vs=p.split('='); parts.append((int(pc,0),[int(v,0) for v in vs.split(',')]))
cells=[]
for part in [x for x in os.environ.get('G','').split(';') if x]:
    a,n,vs=part.split(':'); cells.append((int(a,0),int(n),[int(v,0) for v in vs.split(',')]))
REQ=[int(x,0) for x in os.environ.get('REQ','').split(',') if x]
SLOT=4*int(os.environ.get('SLOT','0'))
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
if REQ:
    scen=[(s,ov) for s,ov in scen if (lambda t:(not t.fault) and all(p in t.executed for p in REQ))(run(W,row,s,ov))]
    print('scenarios reaching',len(scen),flush=True)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    for gcombo in itertools.product(*[c[2] for c in cells]):
        gov=[list(o) for o in ov if not any(o[0]==c[0] for c in cells)]+[[c[0],c[1],v] for c,v in zip(cells,gcombo)]
        for combo in itertools.product(*[v for _,v in parts]):
            nov=list(gov); ok=True
            for (pc,_),v in zip(parts,combo):
                hits=[]
                def watch(uc,ensure,trace,sp,pc=pc):
                    def h(uc_,a,sz,u): hits.append(len(trace.calls))
                    uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
                W.run_original(row,s,[tuple(o) for o in nov],watch=watch)
                if not hits: ok=False; break
                k=hits[0]
                nov=[o for o in nov if o[0]!=W.STUB_OVR+16*k+SLOT]+[[W.STUB_OVR+16*k+SLOT,4,v]]
            if not ok: continue
            tr=run(W,row,s,nov)
            if tr.fault: continue
            if not (tr.executed<=ex and tr.edges<=ed):
                ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,gcombo,combo,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs)
print('untaken',' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
