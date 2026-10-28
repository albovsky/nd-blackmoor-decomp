"""allret.py ROW OUT 'PC=v1,v2;PC=..' [scen..]: like stubret, but EVERY hit of each call PC gets the value (re-discovers the hits after each change, since overrides shift later stubs; env STEP=0x10000 adds i*STEP per hit for pointer values, env ROUNDS=6)"""
import sys,os,itertools; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
import unicorn
key=sys.argv[1]; out=sys.argv[2]; spec=sys.argv[3]; extra=sys.argv[4:]
parts=[]
for p in spec.split(';'):
    pc,vs=p.split('='); parts.append((int(pc,0),[int(v,0) for v in vs.split(',')]))
STEP=int(os.environ.get('STEP','0'),0); ROUNDS=int(os.environ.get('ROUNDS','6'))
REQ=[int(x,0) for x in os.environ.get('REQ','').split(',') if x]
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=400000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
def hits_of(s,nov,pc):
    hits=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u): hits.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
    W.run_original(row,s,[tuple(o) for o in nov],watch=watch)
    return hits
for s,ov in scen:
    for combo in itertools.product(*[v for _,v in parts]):
        nov=[list(o) for o in ov]; done=set()
        for rnd in range(ROUNDS):
            changed=False
            for (pc,_),v in zip(parts,combo):
                for i,k in enumerate(hits_of(s,nov,pc)):
                    if (pc,k) in done: continue
                    nov=[o for o in nov if o[0]!=W.STUB_OVR+16*k]+[[W.STUB_OVR+16*k,4,(v+i*STEP)&0xffffffff]]; done.add((pc,k)); changed=True; break
            if not changed: break
        tr=run(W,row,s,nov)
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,combo,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken])
json.dump({key:kept},open(out,'w'))
