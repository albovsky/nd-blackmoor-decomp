SETS=[]
WR=W.STUB_WR
fix=[]
for k in range(0,160):
    fix+=[(WR+16*k,4,SP),(WR+16*k+4,4,W.STOP)]
SETS.append([(arg(0),4,0x12345678),(arg(1),4,0x9999999a),(arg(2),4,0x3fff),(arg(3),4,0x20),(arg(4),4,0),(arg(5),4,P1)]+fix)
