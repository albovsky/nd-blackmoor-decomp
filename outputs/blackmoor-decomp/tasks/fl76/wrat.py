"""wrat.py ROW OUT CALLPC 'TARGET_EXPR' 'v1,v2,..' [scen..]: at each scenario's first run of CALLPC (a call instruction), make that call's stub also store each value at TARGET_EXPR (python expr over regs and m32(a)/m16(a)); keep what adds coverage.
env WSIZE (default 4), NTH (default 0 = first hit, -1 = every hit tried one at a time up to 8), EAXV (comma list, optional eax for the stub), BIG (extra overrides json)"""
import sys,os,itertools; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
import unicorn
from unicorn import x86_const as X
key=sys.argv[1]; out=sys.argv[2]; callpc=int(sys.argv[3],0); texpr=sys.argv[4]; vals=[int(v,0) for v in sys.argv[5].split(',')]; extra=sys.argv[6:]
WS=int(os.environ.get('WSIZE','4')); NTH=int(os.environ.get('NTH','0'))
EAXV=[int(v,0) for v in os.environ.get('EAXV','').split(',') if v]
pool,W,G,row=setup(key)

scen=F.known_scenarios(key,F.POOLS[pool]['world'],extra)
ex=set();ed=set();kept=[]
for s,ov in scen:
    tr=run(W,row,s,ov)
    if tr.fault: continue
    if not (tr.executed<=ex and tr.edges<=ed): ex|=tr.executed;ed|=tr.edges;kept.append([s,[list(o) for o in ov]])
print('base',cov(G,row,ex,ed)[:4],len(kept),flush=True)
R={n:getattr(X,'UC_X86_REG_'+n.upper()) for n in ('eax','ecx','edx','ebx','esi','edi','ebp','esp')}
for s,ov in scen:
    hits=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            env={n:uc_.reg_read(r) for n,r in R.items()}
            def mk(n):
                def f(ad): return int.from_bytes(bytes(uc_.mem_read(ad&0xffffffff,n)),'little')
                return f
            env.update(m32=mk(4),m16=mk(2),m8=mk(1))
            try: t=eval(texpr,{},env)&0xffffffff
            except Exception as e: t=None
            hits.append((len(trace.calls),t))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=callpc,end=callpc)
    t0=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    sel=hits[:8] if NTH<0 else hits[NTH:NTH+1]
    for k,t in sel:
        if t is None: continue
        for v in vals:
            for ev in (EAXV or [None]):
                nov=[list(o) for o in ov if o[0] not in (W.STUB_WR+16*k,W.STUB_WR+16*k+4,W.STUB_OVR+16*k)]
                nov+=[[W.STUB_WR+16*k,4,t],[W.STUB_WR+16*k+4,WS,v]] if WS==4 else []
                if WS!=4:
                    # sub-dword stores: read-modify via full dword is not available; only 4 supported
                    continue
                if ev is not None: nov+=[[W.STUB_OVR+16*k,4,ev]]
                tr=run(W,row,s,nov)
                if tr.fault: continue
                if not (tr.executed<=ex and tr.edges<=ed):
                    ex|=tr.executed;ed|=tr.edges;kept.append([s,nov]);print('new',s,k,hex(t),hex(v),ev,cov(G,row,ex,ed)[:4],flush=True)
got,total,taken,dirs,missing,untaken=cov(G,row,ex,ed)
print('final',got,total,taken,dirs,[(hex(a),n) for a,n in untaken][:60])
json.dump({key:kept},open(out,'w'))
