import os
# lookup cases: op -> (word offset)
CASES={0x4b:0,0x51:0xa,0x9d:0xaa,0x9f:0x2e,0xa1:0x31}
LONG=int(os.environ.get('LONG','0'))
OPS=[int(x,0) for x in (os.environ.get('OPS') or '0x4b,0x51,0x9d,0x9f,0xa1').split(',')]
WS=[int(x,0) for x in (os.environ.get('WS') or '0xffff,5,0x2710,0').split(',')]
SETS=[]
for op in OPS:
    off=CASES[op]
    for w in WS:
        for dbg in (0,1):
            st=[(arg(0),4,P0),(arg(1),4,P1),(0x5c39e3,2,0),(0x63a4cd,2,dbg)]+S(P0,'ab')
            st+=[(P0+0x30,1,op),(P0+0x31,1,1)]
            st+=[(P0+0x32+off,2,w&0xffff)]
            st+=S(P0+0x32+off+2,'nm')
            st+=S(P2,'hello')
            if LONG: st+=[(P3+4*i,4,0x41414141) for i in range(10002)]+[(P3+40008,1,0)]
            SETS.append(st)
