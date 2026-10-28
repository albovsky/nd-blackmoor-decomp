"""cpset.py ROW OUT PC N [scen..]: at the first hit of the repe cmpsb at PC (n bytes), copy the N bytes at edi onto esi (as byte overrides) so the compare matches; keep coverage adders.
Env SKIP=k uses the k-th hit instead of the first."""
import sys, os; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0]+'/../fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; pc=int(sys.argv[3],16); n=int(sys.argv[4],0); extra=sys.argv[5:]
nth=int(os.environ.get('SKIP','0'))
pool,W,G,row=setup(key)
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    hits=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            hits.append((uc_.reg_read(X.UC_X86_REG_ESI),bytes(uc_.mem_read(uc_.reg_read(X.UC_X86_REG_EDI),n))))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=pc,end=pc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    gc.collect()
    if len(hits)<=nth: continue
    esi,src=hits[nth]
    addrs={esi+i for i in range(n)}
    nov=[list(o) for o in ov if o[0] not in addrs]+[[esi+i,1,src[i]] for i in range(n)]
    tr=run(W,row,s,nov); gc.collect()
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed):
        ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,hex(esi),cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,' '.join('%x%s'%(a,'T' if n_=='taken' else 'F') for a,n_ in untaken))
json.dump({key:kept},open(out,'w'))
