SETS=[]
for ent in (0,1):
  for lo,hi,v in ((0,100,50),(60,100,50),(0,40,50)):
    for cnt in (2,):
      for ecx in (0,1,2):
        k=2 if ent else 1
        st=[R('ecx',0),(arg(5),4,v),(W.STUB_OVR,4,P1),(P1+0x68,4,ent),(W.STUB_OVR+16*k,4,P2),(W.STUB_WR+16*k,4,SP-12),(W.STUB_WR+16*k+4,4,cnt),
            (P2,4,lo),(P2+4,4,hi),(P2+0xc,4,1),(P2+0x10,4,P3),(P3+4,4,(P4 if ecx else 0)),(P4+8,1,(1 if ecx==2 else 0))]
        if ent: st+=[(W.STUB_OVR+16,4,0)]
        SETS.append(st)
