SETS=[]
for sg in (0,0x8000):
  for hi in (0xc0000000,0x80000000):
    for lo in (0,5):
      SETS.append([(arg(0),4,lo),(arg(1),4,hi),(arg(2),4,0x7fff|sg),(arg(3),4,3),(arg(4),4,0),(arg(5),4,P1)])
