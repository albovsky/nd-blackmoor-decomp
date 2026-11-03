SETS=[]
WR=W.STUB_WR
fix=[]
for k in range(0,160):
    fix+=[(WR+16*k,4,SP),(WR+16*k+4,4,W.STOP)]
base=lambda exp,n,flag:[(arg(0),4,0x12345678),(arg(1),4,0x9999999a),(arg(2),4,exp),(arg(3),4,n),(arg(4),4,flag),(arg(5),4,P1)]+fix
SETS.append(base(0x3efe,1,0))
SETS.append(base(0x3fff,0x20,0))
SETS.append(base(0x3fff,0x30,0))
