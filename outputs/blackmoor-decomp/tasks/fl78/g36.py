SETS=[]
for fmt in ('%#.0o','%#o','%#0.0o','%#.0lo'):
    for z in (0x30,):
        st=S(P0,fmt)+[(arg(1),4,P0),(arg(0),4,P3),(SP-0x4c,1,z)]
        for k in range(0,6): st+=[(W.STUB_OVR+16*k,4,0),(W.STUB_OVR+16*k+8,4,0)]
        SETS.append(st)
for fmt in ('%f','%e','%g','%5.2f','%-8.3g','%E','%G'):
    for k in range(0,5):
        for ew in (0x2d,):
            SETS.append(S(P0,fmt)+[(arg(1),4,P0),(arg(0),4,P3),(W.STUB_WR+16*k,4,SP-0x24c),(W.STUB_WR+16*k+4,4,ew)])
