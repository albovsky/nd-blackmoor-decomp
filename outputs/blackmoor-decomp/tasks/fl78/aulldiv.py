import random
M=0xffffffff
def sim(alo,ahi,blo,bhi):
    # after sign normalization (positives only), hi of divisor nonzero
    ebx=bhi; ecx=blo; edx=ahi; eax=alo
    while True:
        cb=ecx&1; ebx>>=1; ecx=(ecx>>1)|((bhi_c:=0)<<31) if False else None
        break
def run(alo,ahi,blo,bhi):
    ebx=bhi; ecx=blo; edx=ahi; eax=alo
    while True:
        ecx=((ebx&1)<<31)|(ecx>>1); ebx>>=1
        eax=((edx&1)<<31)|(eax>>1); edx>>=1
        if ebx==0: break
    q=((edx<<32)|eax)//ecx
    if q>M: return None
    esi=q
    p=esi*bhi; ecx2=p&M
    pr=blo*esi; eax2=pr&M; edx2=(pr>>32)&M
    s=edx2+ecx2
    carry=s>M; edx2=s&M
    if carry: return 'jb5'
    if edx2>ahi: return 'ja'
    return None
random.seed(1)
vals=[0,1,2,3,0x7fffffff,0x7ffffffe,0x10000,0xffff,0x80000000-1,0x12345678,0x40000000,0x3fffffff,0x20000001]
found={}
for _ in range(2000000):
    a=(random.choice(vals+[random.getrandbits(31)]),random.choice(vals+[random.getrandbits(31)]))
    b=(random.choice(vals+[random.getrandbits(32)])&M,random.choice([1,2,3,0x7fffffff,random.getrandbits(31)|0] ) )
    if b[1]==0 or (b[1]>>31): continue
    r=run(a[0],a[1],b[0],b[1])
    if r and r not in found:
        found[r]=(a,b); print(r,[hex(x) for x in a+b])
    if len(found)==2: break
