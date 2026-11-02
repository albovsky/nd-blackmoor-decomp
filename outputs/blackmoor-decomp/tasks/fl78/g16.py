import os
OPS=range(int(os.environ.get('OA','10')),int(os.environ.get('OB','247')))
FILLS=[int(x,16) for x in (os.environ.get('FILLS') or '00000000,01010101,02020202').split(',')]
DBGS=[int(x) for x in (os.environ.get('DBGS') or '0,1').split(',')]
SETS=[]
for op in OPS:
    for f in FILLS:
        for dbg in DBGS:
            st=[(arg(0),4,P0),(arg(1),4,P1),(0x5c39e3,2,0),(0x63a4cd,2,dbg)]+S(P0,'ab')
            st+=[(P0+0x30,1,op),(P0+0x31,1,1)]
            st+=[(P0+0x32+4*i,4,f) for i in range(64)]
            SETS.append(st)
