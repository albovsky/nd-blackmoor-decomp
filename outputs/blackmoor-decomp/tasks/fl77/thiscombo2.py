"""thiscombo2.py (FL-77: a path ['A', 0x594d80] is an absolute address)
thiscombo.py ROW OUT 'EXPR' [scen..]: EXPR = python list of combos; a combo is a list of ([off0, off1, ..], size, val): the cell is [..[this+off0]+off1..]+offN with `this` = ecx at entry
(every offset but the last is dereferenced as a dword). Env PC=hex hooks that pc instead of the entry; REG=edx etc. picks another entry register, ARG=n uses the dword at [esp+4*n] at entry instead. Each combo is applied to every known scenario;
coverage adders are kept."""
import sys, os, struct; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; combos=eval(sys.argv[3]); extra=sys.argv[4:]
pool,W,G,row=setup(key)
if os.environ.get('LIM'): W.INSTRUCTION_LIMIT=int(os.environ['LIM'])
scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
for s,ov in scen:
    box=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            if os.environ.get('ARG'):
                esp=uc_.reg_read(X.UC_X86_REG_ESP); t=struct.unpack('<I',bytes(uc_.mem_read(esp+4*int(os.environ['ARG']),4)))[0]
            else: t=uc_.reg_read(getattr(X,'UC_X86_REG_'+os.environ.get('REG','ecx').upper()))
            box.append(t)
            def rd(a): return struct.unpack('<I',bytes(uc_.mem_read(a,4)))[0]
            box.append(rd)
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=row_pc,end=row_pc)
    row_pc=int(os.environ['PC'],16) if os.environ.get('PC') else int(key,16)
    # resolve the pointer chains in a probe run, then run each combo
    chains={}
    def watch2(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            if os.environ.get('ARG'):
                esp=uc_.reg_read(X.UC_X86_REG_ESP); t=struct.unpack('<I',bytes(uc_.mem_read(esp+4*int(os.environ['ARG']),4)))[0]
            else: t=uc_.reg_read(getattr(X,'UC_X86_REG_'+os.environ.get('REG','ecx').upper()))
            chains['this']=t
            def rd(a): return struct.unpack('<I',bytes(uc_.mem_read(a,4)))[0]
            for c in combos:
                for path,size,val in c:
                    if path and path[0]=='A': chains[(tuple(path))]=path[1]; continue     # FL-77: ['A', addr] is an absolute address
                    a=t
                    for o in path[:-1]: a=rd(a+o)
                    chains[(tuple(path))]=a+path[-1]
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=row_pc,end=row_pc)
    W.run_original(row,s,[tuple(o) for o in ov],watch=watch2); gc.collect()
    if 'this' not in chains: continue
    HITS=globals().get('HITS',0)+1; globals()['HITS']=HITS
    if os.environ.get('MAXHIT') and HITS>int(os.environ['MAXHIT']): continue
    for c in combos:
        cells=[[chains[tuple(p)],sz,v] for p,sz,v in c if tuple(p) in chains]
        nov=[list(o) for o in ov if not any(o[0]<c[0]+c[1] and c[0]<o[0]+o[1] for c in cells)]+cells
        try: tr=run(W,row,s,nov)
        except Exception: continue
        gc.collect()
        if tr.fault:
            if os.environ.get('DBG'): print('fault',s,tr.fault,max(tr.executed) if tr.executed else None,flush=True)
            continue
        if os.environ.get('KEEPALL') or not (tr.executed<=ex and tr.edges<=ed):
            ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
