"""try.py ROW SCEN_INDEX_OR_SEED 'ovlist' PCS: run one scenario seed with extra overrides, print which PCS executed"""
import sys; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
from drv import *
key=sys.argv[1]; seed=int(sys.argv[2]); ovl=eval(sys.argv[3]); pcs=[int(x,16) for x in sys.argv[4].split(',')]; extra=sys.argv[5:]
pool,W,G,row=setup(key); W.INSTRUCTION_LIMIT=200000
for s,ov in F.known_scenarios(key,F.POOLS[pool]['world'],extra):
    if s!=seed: continue
    nov=[list(o) for o in ov]+[list(o) for o in ovl]
    tr=run(W,row,s,nov)
    print(s,'fault',tr.fault,{hex(p):p in tr.executed for p in pcs})
    got,total,taken,dirs,missing,untaken=cov(G,row,tr.executed,tr.edges)
    print(got,total,taken,dirs,[(hex(a),n) for a,n in untaken][:6])
    break
