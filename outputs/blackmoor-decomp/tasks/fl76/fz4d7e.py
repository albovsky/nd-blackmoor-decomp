"""fz4d7e.py OUT [scen..]: 0x4d7ea4 three inlined strcmp(buf_j, str_j): buf_j is zeroed by the function, so one callee store (the fread stub at 0x4d7fc7) puts 4 bytes into ONE buf_j; str_j are bss globals set by image overrides."""
import sys,json,itertools; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
key='0x4d7ea4'; out=sys.argv[1]; files=sys.argv[2:]
pool,W,G,row=setup(key)
scen=F.known_scenarios(key,F.POOLS[pool]['world'],files)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
STR=[0x5b0113,0x5b0131,0x5b014f]; BUF=[0x98b0,0x98ce,0x98ec]
PAT=[(b'ab\0\0',b'ab\0\0'),(b'ab\0\0',b'ac\0\0'),(b'a\0\0\0',b'a\0\0\0'),(b'ab\0\0',b'xb\0\0'),(b'a\0cd',b'a\0cd')]
for s,ov in scen:
    if s>400: continue
    hits=[];thisv=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u): hits.append(len(trace.calls))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=0x4d7fc7,end=0x4d7fc7)
    t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch,observe=True)
    if not hits: continue
    k=hits[0]
    w=[a-0x98ac for a,sz,v in t0.writes if (a&0xfff)==((0)&0xfff) or True]
    # this = (address stored at 0x4d7f94 [edx+0x98ac]) -> find the write of size 4 right after call 50d0a9; use reads at 0x4d7f91 ([ebp-4])
    th=[v for (a,n,v,wc),p in zip(t0.reads,t0.read_pcs) if p==0x4d7f91]
    if not th: continue
    this=th[0]
    for j,(b,sv) in itertools.product(range(3),PAT):
        for two in (0,1):
            nov=[o for o in ov if not(W.STUB_WR<=o[0]<W.STUB_WR+0x10000)]
            nov+=[[STR[j],4,int.from_bytes(sv,'little')],[W.STUB_WR+16*k,4,this+BUF[j]],[W.STUB_WR+16*k+4,4,int.from_bytes(b,'little')]]
            tr=run(W,row,s,nov); gc.collect()
            if tr.fault: continue
            if not (tr.executed<=ex and tr.edges<=ed):
                ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,j,b,sv,cov(G,row,ex,ed)[:4],flush=True)
            break
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[hex(x) for x in missing][:10])
print('untaken',' '.join('%x%s'%(a,'T' if n=='taken' else 'F') for a,n in untaken))
json.dump({key:kept},open(out,'w'))
