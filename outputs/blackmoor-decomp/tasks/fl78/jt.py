import sys,struct
sys.path.insert(0,'/home/user/wt-scen/outputs/blackmoor-decomp/tasks/fl73/tools')
from disx import rd
bm=rd(0x410e9c,0xed)
jt=rd(0x410ca4,4*max(bm)+4)
m={}
for i,b in enumerate(bm):
    t=struct.unpack_from('<I',jt,4*b)[0]
    m.setdefault(t,[]).append(i+10)
for t in sorted(m): print('%x'%t,' '.join(hex(x) for x in m[t]))
