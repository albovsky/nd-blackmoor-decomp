SETS=[]
strs=["<e>","ab<c>1<l>2<l>3<f>4<n>5<r>6<t>7<u>8<u>9<w>x<x>ZZ<e>","q<c12><l><l><e>"]
for st in strs:
  for a2 in (-1,-2,5):
    for a3 in (0,1):
      for g in (0,1):
        SETS.append([R('ecx',P0),(arg(1),4,P2)]+S(P2,st)+[(arg(2),4,a2&0xffffffff),(arg(3),4,a3),(0x5a161f,1,g),(P0+0x34,4,0),(P0+0x2e,4,0)])
