# alloc returns the opcode byte address so the record copy rewrites the opcode after dispatch
SETS=[]
for op,newop,sz,k in ((0x16,0x20,0x16,2),(0x17,0x20,0x16,2),(0x1e,0x41,1,2),(0x1f,0x41,1,2),(0x1e,0x1f,1,2),(0x1f,0x1e,1,2)):
    st=[(arg(0),4,P0),(arg(1),4,P1),(0x5c39e3,2,0),(0x63a4cd,2,1)]+S(P0,'ab')
    st+=[(P0+0x30,1,op),(P0+0x31,1,1)]
    st+=[(P0+0x32+4*i,4,0) for i in range(8)]
    st+=[(P0+0x32,1,newop)]
    st+=[(W.STUB_OVR+16*k,4,0x5bb5e3)]
    SETS.append(st)
