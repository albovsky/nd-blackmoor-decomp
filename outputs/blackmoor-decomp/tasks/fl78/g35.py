import random
rng=random.Random(35)
SETS=[]
flags=['','-','+',' ','#','0','-0','+ ','#0','-+ #0']
widths=['','5','*','12','0','-*','1*']
precs=['','.','.3','.*','.0','.12']
sizes=['','h','l','w','I','I64','I6','I3','I32','L','hh','ll']
convs='dicsuxXpnfeEgGoSZCaAF%'
for i in range(1800):
    s=''
    for _ in range(rng.randint(1,2)):
        s+=rng.choice(['','a','ab'])+'%'+rng.choice(flags)+rng.choice(widths)+rng.choice(precs)+rng.choice(sizes)+rng.choice(convs)
    SETS.append(S(P0,s)+[(arg(1),4,P0),(arg(0),4,P3)])
