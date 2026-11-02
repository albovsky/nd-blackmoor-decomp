import random
rng=random.Random(44)
SETS=[]
E=P1+0x4000
for _ in range(700):
    S_=rng.choice((0x21,0x41,0x81,0x201,0x401,0x421))
    N=rng.choice((0x40,0x41,0x200,0x20,0x420,0x600,0x410))
    prev=rng.choice((1,0x40,0x20,0x200,0x220,0x240,0x230,0x260,0x400,0x3,0x41))
    c1=rng.choice((0,1,2)); c2=rng.choice((0,1,2))
    nl=rng.choice((0,1)); pl=rng.choice((0,1))
    st=[(arg(0),4,P0),(P0+0xc,4,P1),(P0+0x10,4,P2),(arg(1),4,E),(arg(2),4,0),
        (E-4,4,S_),(E-8,4,prev),(E+S_-5,4,N),
        (E+S_-1,4,P4),(E+S_+3,4,(P4 if nl==0 else P5)),
        (E-4-prev+4,4,P4),(E-4-prev+8,4,(P4 if pl==0 else P5)),
        (P2+0x44,4,rng.getrandbits(32)),(P2+0xc4,4,rng.getrandbits(32))]
    for i in range(0x44):
        st.append((P2+4+i,1,rng.choice((c1,c2,1))))
    if rng.random()<0.6: st+=[(P2+0x144+8*i+4,4,P2+0x144+8*i) for i in range(0x40)]
    SETS.append(st)
