import os, random
NSETS=int(os.environ.get('NSETS','300'))
RS=int(os.environ.get('RS','1'))
rnd=random.Random(RS)
SETS=[]
for t in range(NSETS):
    op=rnd.choice([0x97,0x9e])
    dbg=rnd.choice([0,1])
    n=rnd.choice([1,1,2,2,3,3,12])
    D=P0+0x32
    st=[(arg(0),4,P0),(arg(1),4,P1),(0x5c39e3,2,0),(0x63a4cd,2,dbg)]+S(P0,'ab')
    st+=[(P0+0x30,1,op),(P0+0x31,1,1)]
    st+=[(D,2,n)]
    sel=[]
    for i in range(n):
        k=rnd.choice([0x2a,0x41,0x2a])
        sel.append(k)
        st+=[(D+2+0x21*i,1,k)]
        st+=S(D+3+0x21*i,'e%d'%i)
    X=D+(n-1)*0x21+2 if n<10 else D+2
    # fixed record at X: zeros for bytes 1..0x2d (cells to keep it defined)
    st+=[(X+4*j,4,0) for j in range(1,0x2c//4+1)] if n<10 else []
    st+=[(X,1,sel[-1])] if n<10 else []
    I=X+0x2e
    for j in range(n if n<10 else 0):
        w=rnd.choice([-1,-1,0,3,-2,5])
        st+=[(I,2,w&0xffff)]
        if w==-1:
            st+=S(I+2,'nm%d'%j); I+=0x23
        elif w>=0:
            st+=S(I+2,'abcde'[:w]); I+=w+2
        else:
            I+=2
    SETS.append(st)
