SETS=[]
for cnt in (11,12):
  for sd in (0,):
    st="ab<c>1<l>2<e>"
    ov=[R('ecx',P0),(arg(0),4,P1),(arg(1),4,P3),(arg(2),4,0),(arg(3),4,0)]+S(P3,st)
    ov+=[(P1,2,0),(P1+2,2,2),(P1+8,2,3),(P1+0xa,2,4),(P1+0xc,2,12),(P1+0xe,2,3),(P1+0x31,2,cnt)]+S(P1+0x10,'ab')
    ov+=[(0x5d0397+4*i,4,P2) for i in range(6)]+[(P0+6,4,0),(P0+0x2930,4,0)]
    SETS.append(ov)
