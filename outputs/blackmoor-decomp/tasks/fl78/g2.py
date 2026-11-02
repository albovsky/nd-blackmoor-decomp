SETS=[]
st="ab<c>1<l>2<l>3<f>4<n>5<r>6<t>7<u>8<u>9<w>x<x>ZZ<e>"
variants=[
 [(0x5b0a32,2,0),(0x5b0a34,2,1),(0x5b0a2e,4,100),(0x5b0a26,4,10),(0x5b0a1e,4,10)],   # jl T, jle T
 [(0x5b0a32,2,0),(0x5b0a34,2,1),(0x5b0a2e,4,100),(0x5b0a26,4,0),(0x5b0a1e,4,0),(0x5b0a16,4,0xfffffff6)],  # jle F, jg F
 [(0x5b0a32,2,0),(0x5b0a34,2,1),(0x5b0a2e,4,100),(0x5b0a26,4,0),(0x5b0a1e,4,0),(0x5b0a16,4,0)],  # jle F, jg T?
 [(0x5b0a32,2,0),(0x5b0a34,2,1),(0x5b0a2e,4,100),(0x5b0a26,4,0),(0x5b0a1e,4,0),(0x5b0a16,4,0xffffff00)],
]
for v in variants:
  SETS.append([R('ecx',P0),(arg(1),4,P2)]+S(P2,st)+[(arg(2),4,0xfffffffe),(arg(3),4,0),(0x5a161f,1,1),(P0+0x34,4,0),(P0+0x2e,4,0)]+v)
