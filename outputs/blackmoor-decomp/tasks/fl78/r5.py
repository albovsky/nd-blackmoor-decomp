import sys
S=0x20040000
A=int.from_bytes(b'A'*0x30,'little')
fill=int.from_bytes(b'A'*1000,'little')
short=[('g',S,0x30,A),('g',S+0x30,4,0)]
big=[('g',S+1000*i,1000,fill) for i in range(41)]
R=[]
for pc,cmp_ in ((0x4e6130,0x4e6181),(0x4e6330,0x4e6366)):
    for sv in (0,1):
        R.append(short+[('ret',pc,0,S),('ret',cmp_,0,sv)])
    R.append(big+[('ret',pc,0,S)])
    R.append([('g',S,4,0),('ret',pc,0,S),('ret',cmp_,0,1)])
print(repr(R))
