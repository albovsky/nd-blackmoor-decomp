import random
SETS=[]
rng=random.Random(int(os.environ.get('RS','1')))
N=int(os.environ.get('NSET','40'))
for k in range(N):
    ov=[R('ecx',P0),(arg(0),2,rng.choice([9,13,14,15])),(arg(1),2,rng.choice([0,1])),(arg(2),2,rng.choice([0,1,2]))]
    ov+=[(P0+0x53bd,2,rng.choice([1,2,3])),(P0+0x53bf,2,rng.choice([0,1,2])),(P0+0x65d6,2,rng.choice([0,1,2]))]
    ov+=[(0x5a1e58,4,rng.choice([0,1]))]
    ov+=[(0x5a26aa+0x4a*i,4,rng.choice([0,1])) for i in range(0,5)]
    ov+=[(0x585d51,2,rng.choice([3,12])),(0x585d4f,2,rng.choice([3,12]))]
    SETS.append(ov)
