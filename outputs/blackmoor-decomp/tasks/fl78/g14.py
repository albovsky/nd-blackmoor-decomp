import random,re
SETS=[]
rng=random.Random(int(os.environ.get('RS','1')))
N=int(os.environ.get('NSET','40'))
txt=open('/home/user/wt-scen/outputs/blackmoor-decomp/tasks/fl78/d4c1716.txt').read()
init=eval(open('/home/user/wt-scen/outputs/blackmoor-decomp/tasks/fl78/init4c.txt').read())
DS=sorted(set(int(a,16) for a in re.findall(r'\[e[a-ds][xip] \+ (0x[0-9a-f]+)\]',txt) if int(a,16)>=0x10))
GLB=sorted(set(int(a,16) for a in re.findall(r'ptr \[(0x[56][0-9a-f]{5})\]',txt)))
def v(): return rng.choice([0,0,1,1,2,0x1000,0x40,0x1040,0xffffffff,0x7c,3])
def sv(): return rng.choice([0,0,0,1,1,2,0x40,0x1000,0x20060000]) if rng.random()<0.9 else 0xffffffff
for k in range(N):
    ov=[tuple(o) for o in init]
    for d in DS:
        if d in (4,8,0xc,0x1f24): continue
        ov.append((P0+d,4,v())); ov.append((P1+d,4,v()))
    ov.append((P1+0x175c,4,0)); ov.append((P0+0x1f2c,4,P1))
    for a in GLB: ov.append((a,4,v()))
    ov.append((0x63a4cd,2,rng.choice([0,1])))
    EBP=W.SP-4
    for off in range(0x8c,4,-4):
        ov.append((EBP-off,4,rng.choice([0,1,2,0xffffffff,rng.getrandbits(32),rng.getrandbits(32)&rng.getrandbits(32)&rng.getrandbits(32),0x1000,0x40,0xfffffff0])))
    if rng.random()<0.6:
        ov+=[(P0+0xdfa,4,0x1000|rng.choice([0,1])),(P0+0xe42,4,0x40),(P0+0xe4a,4,5),(0x639893,2,5)]
    for kk in range(90):
        ov.append((W.STUB_OVR+16*kk,4,sv())); ov.append((W.STUB_OVR+16*kk+4,4,sv())); ov.append((W.STUB_OVR+16*kk+8,4,sv()))
    m38=rng.choice([0,1]); gg=int(os.environ.get('GG','0'))
    ov+=[(P0+0xc66,4,rng.choice([0,1])),(P0+0xc4e,4,rng.choice([0,1,1]))]
    ov+=[(P0+0x38ac,4,m38),(P1+0x38ac,4,m38),(0x63a4cd,2,gg)]
    for kk in range(90):
        ov+=[(W.STUB_WR+16*kk,4,EBP-0x1c),(W.STUB_WR+16*kk+4,4,rng.choice([0xffffffff,0xffffffff,0,rng.getrandbits(32)]))]
    for kk in (2,5):
        ov+=[(W.STUB_WR+16*kk,4,P0+0xe42),(W.STUB_WR+16*kk+4,4,0x40)]
    ov+=[(0x639893,2,rng.choice([0,5]))]
    SETS.append(ov)
