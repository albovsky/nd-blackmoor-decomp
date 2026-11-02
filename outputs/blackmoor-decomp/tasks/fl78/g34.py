import random
rng=random.Random(34)
SETS=[]
alpha='-+ #0*123456789.hlwI64dicsuxXpnfeEgGoSZCa%'
conv='dicsuxXpnfeEgGoSZC%'
for i in range(400):
    s=''
    for _ in range(rng.randint(1,3)):
        s+=rng.choice(['','a','%'])+'%'
        for _ in range(rng.randint(0,6)): s+=rng.choice(alpha)
        s+=rng.choice(conv)
    SETS.append(S(P0,s)+[(arg(1),4,P0),(arg(0),4,P3)])
