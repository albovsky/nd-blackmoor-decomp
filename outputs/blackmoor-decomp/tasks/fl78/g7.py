import random,re
SETS=[]
rng=random.Random(int(os.environ.get('RS','1')))
N=int(os.environ.get('NSET','40'))
txt=open('/home/user/wt-scen/outputs/blackmoor-decomp/tasks/fl78/d4f0059.txt').read()
GL=sorted(set(int(a,16) for a in re.findall(r'ptr \[(0x5[0-9a-f]{5})\]',txt)))
def v(): return rng.choice([0,0,0,0,1,1,1,2,2,3,0xffffffff,0xffff])
for k in range(N):
    ov=[R('ecx',P0)]
    for a in GL:
        ov.append((a,4,v()))
    # this struct fill
    for o in range(0,0x84,4): ov.append((P0+o,4,v()))
    # table entries -> structs
    nt=3
    for i in range(nt):
        ptr=P4+0x1000*i
        ov.append((0x5bb5e5+0x8d*i,4,ptr))
        if rng.random()<0.5:
            for o in range(0,0x700,4): ov.append((ptr+o,4,v()))
        else:
            for o in range(0,0x700,1): ov.append((ptr+o,1,rng.choice([0,0,0,1,1,2,0xff])))
        ov.append((ptr+0x21,2,rng.choice([0,1,2,3,4])))
        ov.append((ptr+0x23,2,rng.choice([0,1,2,3])))
    # indexes
    for a in (0x5b5159,0x5b615f,0x5b61b0,0x5b51fb,0x583a29):
        ov.append((a,4,rng.choice([0,1,2,0xffff])))
    for a in (0x5b5158,0x5b61af,0x5b615e):
        ov.append((a,1,rng.choice([0,1,1])))
    # 4f1dc4 tail: records at 0x5bb5e3 + 0x8d*i
    ov.append((0x5c39e3,2,rng.choice([2,3,4,6])))
    ov.append((0x5b4e89,2,rng.choice([0xffff,50])))
    ov.append((0x5b5100,2,rng.choice([0xffff,50,1])))
    ov.append((0x5a4c18,4,rng.choice([0,1,2,0,1,2,3])))
    ov.append((0x5bb2d0,2,rng.choice([0x4d,0,0x4d])))
    for i in range(6):
        rec=0x5bb5e3+0x8d*i
        ov.append((rec,1,rng.choice([0xb,0xc,0x1b,0x42,0x62,0x63,0x7a,0x7b,0x90,0xe,0xd]) if rng.random()<0.7 else 0xb+rng.randrange(0x70)))
        ov.append((rec+0x43,4,rng.choice([0,1,1,1])))
        wide=rng.random()<0.6
        for o,wv in ((0x47,0x8000),(0x49,0x8000),(0x4b,0x7fff),(0x4d,0x7fff)): ov.append((rec+o,2,wv if wide else rng.choice([0,1,2,3])))
        ptr=P4+0x1000*i
        ov.append((rec+2,4,ptr))
        for o in range(0,0x90,2): ov.append((ptr+o,2,rng.choice([0,1,2,3,4,0x10,0x1c,0xffff])))
    for ii in range(4):
        for jj in range(6):
            ov.append((0x591990+0xc*ii+2*jj,2,rng.choice([0xfff6,0xfff6,0,1])))
    if os.environ.get('FORCE'):
        SP_T=[0xb,0xc,0x1b,0x42,0x62,0x63,0x7a,0x7b,0x90,0xe,0xd]
        rec=0x5bb5e3
        ov+=[(rec,1,int(os.environ['FT'],0) if os.environ.get('FT') else SP_T[k%len(SP_T)]),(rec+0x43,4,1),(rec+0x47,2,0x8000),(rec+0x49,2,0x8000),(rec+0x4b,2,0x7fff),(rec+0x4d,2,0x7fff),
             (0x5c39e3,2,3),(0x5b4e89,2,0xffff),(0x5b5100,2,0xffff),(0x5b5158,1,0),(0x5b61af,1,0),(0x5b615e,1,0),(0x5b51f6,1,0),(0x5b51c6,1,0),(0x5b51ab,1,0),(0x5a4c18,4,rng.choice([0,1,2,0]))]
        ov+=[(a_,4,0) for a_ in (0x583102,0x58310a,0x583106,0x58310e,P0+4,P0+8,P0+0xc,P0+0x10)]
        ov+=[(0x583a29,2,rng.choice([0xffff,0xffff,5,0])),(0x5b44f8,4,rng.choice([0,1]))]
        ov+=[(0x5b4e89,2,rng.choice([0xffff,0,0])),(0x5b5100,2,rng.choice([0xffff,0,0])),(0x5b4e14,4,rng.choice([0,1])),(P4+0x48,2,rng.choice([0,1,1]))]
        for o in (0,8,0x28): ov.append((P4+o,2,rng.choice([5,10,0x1c,0xffff,2,0x1a,4])))
        if rng.random()<0.5:
            for o in (0x47,0x49): ov.append((rec+o,2,rng.choice([0x8000,0,1])))
            for o in (0x4b,0x4d): ov.append((rec+o,2,rng.choice([0x7fff,0,1,5])))
    if os.environ.get('ZERO'):
        ov+=[(W.STUB_OVR+16*kk,4,0) for kk in range(44)]
    SETS.append(ov)
