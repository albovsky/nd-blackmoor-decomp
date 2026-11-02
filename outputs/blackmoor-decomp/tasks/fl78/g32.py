SETS=[]
import itertools
E=0xe06d7363; M=0x19930520
for s10,s14,s1c,mm,cnt in itertools.product((3,2),(M,5),(0,1),(0,2),(0,2)):
    st=[(arg(0),4,P0),(arg(1),4,P6),(arg(4),4,P7),(P7+4,4,10),(P6+8,4,3),
        (P0,4,E),(P0+0x10,4,3),(P0+0x14,4,M),(P0+0x1c,4,0),
        (W.STUB_OVR,4,P1),(W.STUB_OVR+16,4,P1),(W.STUB_OVR+32,4,P1),(W.STUB_OVR+48,4,1),
        (P1+0x6c,4,P2),(P1+0x70,4,7),
        (P2,4,E),(P2+0x10,4,s10),(P2+0x14,4,s14),(P2+0x1c,4,(P3 if s1c else 0)),
        (W.STUB_OVR+64,4,P5),
        (P5,4,0),(P5+4,4,5),(P5+0xc,4,mm),(P5+0x10,4,P4),
        (P3+0xc,4,P4),(P4,4,cnt),(P4+4,4,P2+0x100),
        (SP-8,4,0),(W.STUB_WR+64,4,SP-28),(W.STUB_WR+68,4,2)]
    SETS.append(st)
