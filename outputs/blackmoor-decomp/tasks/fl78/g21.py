SETS=[]
for op in (0x2d,0x2e):
    st=[(arg(0),4,P0),(arg(1),4,P1),(0x5c39e3,2,0),(0x63a4cd,2,1)]+S(P0,'ab')
    st+=[(P0+0x30,1,op),(P0+0x31,1,1)]+[(P0+0x32+4*i,4,0) for i in range(8)]
    SETS.append(st)
