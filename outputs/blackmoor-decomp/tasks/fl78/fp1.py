import sys,json,struct
sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
# fp1.py ROW OUT SEEDS(a-b): x := first fret of the 2nd stub call (st0 of the first FP callee), eax of stub 0 = 0
key=sys.argv[1]; out=sys.argv[2]; a,b=sys.argv[3].split('-')
pool,W,G,row=setup(key)
SP=W.SP
def arg(n): return SP+4+4*n
ex=set(); ed=set(); kept=[]
for s in range(int(a),int(b)):
    ov0=[(W.STUB_OVR,4,0)]
    tr=run(W,row,s,ov0)
    if tr.fault or len(tr.calls)<2 or len(tr.calls[1])<9: continue
    bits=tr.calls[1][8]
    ov=ov0+[(arg(0),4,bits&0xffffffff),(arg(1),4,bits>>32)]
    for o in (ov0,ov):
        t=run(W,row,s,o)
        if t.fault: continue
        if not (t.executed<=ex and t.edges<=ed):
            ex|=t.executed; ed|=t.edges; kept.append([s,[list(x) for x in o]])
            print('kept',s,cov(G,row,ex,ed)[:4],flush=True)
json.dump({key:kept},open(out,'w'))
print('final',cov(G,row,ex,ed))
