import random
rnd=random.Random(5)
SETS=[]
for t in range(300):
    n=rnd.choice([9,10,12])
    st=[(arg(0),4,P0),(arg(1),4,n),(arg(2),4,4),(arg(3),4,0x401000)]
    for k in range(14):
        st.append((W.STUB_OVR+16*k,4,rnd.choice([1,0xffffffff,0,1,0xffffffff])))
    SETS.append(st)
