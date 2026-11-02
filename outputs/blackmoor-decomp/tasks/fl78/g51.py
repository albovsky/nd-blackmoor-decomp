import random
rng=random.Random(51)
SETS=[]
A=P2
for _ in range(500):
    N=rng.choice((1,2,3,4))
    c=rng.randint(0,N)
    st=[(arg(0),4,rng.choice((0x10,0x20,0x80,0x200,0x400))),(0x63cdd0,4,N),(0x63cdd4,4,A),(0x63cdc8,4,A+0x14*c)]
    for i in range(N+1):
        base=A+0x14*i
        bm=rng.choice((0,0,0xffffffff,0x80000000,1))
        st+=[(base,4,bm),(base+4,4,rng.choice((0,0,0xffffffff))),(base+8,4,rng.choice((0,0,1))),(base+0x10,4,P3+0x400*i),(P3+0x400*i,4,rng.choice((0xffffffff,0,5,0x40)))]
    st+=[(W.STUB_OVR,4,rng.choice((0,A,P3,A+0x14,0xffffffff))),(W.STUB_OVR+16,4,rng.choice((0,A,P3,1,0xffffffff))),(W.STUB_OVR+32,4,rng.choice((0,1,A,0xffffffff)))]
    SETS.append(st)
