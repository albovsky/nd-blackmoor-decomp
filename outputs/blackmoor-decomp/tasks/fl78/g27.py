def S(addr,text):
    b=text.encode('latin1')
    return [(addr+i,1,c) for i,c in enumerate(b+b'\0')]
SETS=[[(arg(0),4,P0),(arg(1),4,P1),(arg(2),4,P2),(arg(3),4,P3),(arg(4),4,P4)]+S(P0,'a'*300+'\\'+'b'+'.c')]
