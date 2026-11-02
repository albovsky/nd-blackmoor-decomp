import random
SETS=[]
rng=random.Random(int(os.environ.get('RS','1')))
N=int(os.environ.get('NSET','40'))
letters="12345 7cefHLlnrtuw x6".replace(' ','')
def mkstr():
    out=''
    for _ in range(rng.randrange(1,6)):
        out+=rng.choice(['ab','a','','xyz'])+'<'+rng.choice(letters)+rng.choice(['','7','2'])+'>'
    return out
for k in range(N):
    st=mkstr()
    ov=[R('ecx',P0),(arg(0),4,P1),(arg(1),4,P3),(arg(2),4,rng.choice([0,P5])),(arg(3),4,rng.choice([0,P6]))]+S(P3,st)
    ov+=[(P1,2,rng.choice([0,2])),(P1+2,2,rng.choice([0,1,2,3,5,6,-1&0xffff])),(P1+8,2,rng.choice([0,3,5])),(P1+0xa,2,rng.choice([0,4,9])),(P1+0xc,2,rng.choice([1,6,12,40])),(P1+0xe,2,rng.choice([0,3])),(P1+0x31,2,rng.choice([0,1,2,3]))]
    ov+=S(P1+0x10,rng.choice(['','ab']))
    for i in range(3):
        ov+=[(P1+0x33+0x12*i,2,rng.choice([0,1,2,3]))]
    ov+=[(0x5d0397+4*i,4,rng.choice([0,P2,P4])) for i in range(6)]
    ov+=[(P0+6,4,rng.choice([0,P2])),(P0+0x2930,4,rng.choice([0,1,0])),(P0+0x2938,4,rng.choice([0,1])),(P0+0x293e,4,rng.choice([0,1])),(P0+0x2942,4,0)]
    SETS.append(ov)
