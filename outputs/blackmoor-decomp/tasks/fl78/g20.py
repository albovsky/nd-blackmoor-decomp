SETS=[]
for op in (0x97,0x9e):
    D=P0+0x32
    st=[(arg(0),4,P0),(arg(1),4,P1),(0x5c39e3,2,0),(0x63a4cd,2,1)]+S(P0,'ab')
    st+=[(P0+0x30,1,op),(P0+0x31,1,1)]
    st+=[(D,2,1)]+[(D+2,1,0x2a)]+S(D+3,'e0')
    X=D+2
    st+=[(X+4*j,4,0) for j in range(1,0x2c//4+1)]+[(X,1,0x2a)]
    st+=[(X+0x2e,2,0xffff)]+S(X+0x30,'nm0')
    st+=S(P2,'hello')
    st+=[(P3+4*i,4,0x41414141) for i in range(10002)]+[(P3+40008,1,0)]
    SETS.append(st)
