SETS=[]
for k in range(0,4):
    for k2 in range(1,3):
        for a2 in (1,5,0x500):
            SETS.append([(arg(2),4,a2),(W.STUB_OVR+16*k,4,0),(W.STUB_OVR+16*(k+k2),4,5)])
