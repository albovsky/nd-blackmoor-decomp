"""fuzzc.py ROW OUT 'CELLS' [scen..]: like thiscombo but CELLS = list of (path,size,[values]); env N random combos per scenario (default 40), RS seed, PC/REG as thiscombo,
REQ=hexpc keeps only scenarios that execute that pc, P=prob each cell is set (default 0.7). Keeps coverage adders."""
import sys, os, struct, random; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; cells=eval(sys.argv[3]); extra=sys.argv[4:]
pool,W,G,row=setup(key)
if os.environ.get('LIM'): W.INSTRUCTION_LIMIT=int(os.environ['LIM'])
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
N=int(os.environ.get('N','40')); P=float(os.environ.get('P','0.7')); rnd=random.Random(int(os.environ.get('RS','1')))
REQ=int(os.environ['REQ'],16) if os.environ.get('REQ') else None
ex=set();ed=set();kept=[]
base=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
    if REQ is None or REQ in tr.executed: base.append((s,ov))
print('base',cov(G,row,ex,ed)[:4],len(kept),len(base),flush=True)
row_pc=int(os.environ['PC'],16) if os.environ.get('PC') else int(key,16)
for s,ov in base:
    chains={}
    def watch2(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            t=uc_.reg_read(getattr(X,'UC_X86_REG_'+os.environ.get('REG','ecx').upper()))
            def rd(a): return struct.unpack('<I',bytes(uc_.mem_read(a,4)))[0]
            for path,size,vals in cells:
                a=t
                try:
                    for o in path[:-1]: a=rd(a+o)
                    chains[tuple(path)]=a+path[-1]
                except Exception: pass
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=row_pc,end=row_pc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch2); gc.collect()
    if not chains: continue
    for _ in range(N):
        cs=[[chains[tuple(p)],sz,rnd.choice(vs)] for p,sz,vs in cells if tuple(p) in chains and rnd.random()<P]
        nov=[list(o) for o in ov if not any(o[0]<c[0]+c[1] and c[0]<o[0]+o[1] for c in cs)]+cs
        try: tr=run(W,row,s,nov)
        except Exception: continue
        gc.collect()
        if tr.fault: continue
        if not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
