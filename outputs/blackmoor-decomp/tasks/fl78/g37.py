SETS=[]
for pre in ('%','%l','%h','%I64','%5.2','%-','%#','%0','%+','% ','%w'):
    for c in range(0x20,0x7f):
        SETS.append(S(P0,pre+chr(c))+[(arg(1),4,P0),(arg(0),4,P3)])
