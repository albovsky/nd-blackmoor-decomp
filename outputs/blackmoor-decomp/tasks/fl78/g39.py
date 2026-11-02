import itertools
SETS=[]
bufs=[b'a\r',b'\r',b'\r\n',b'ab\r',b'zz']
for fl,peek in ((0x80,0xa),(0x80|0x08,0x41),(0x80|0x48,0xa),(0x80|0x48,0x41)):
    for buf in bufs:
        for cnt in (len(buf),0):
          for k0,k1,k2 in ((1,1,1),(1,0,0),(1,0,5),(0,5,0),(0,0x6d,0),(0,3,0),(0,6,0)):
            for c2,b2 in ((1,0xa),(1,0x41),(0,0xa)):
                st=[(arg(0),4,0),(0x63cde0,4,P1),(P1+4,1,fl),(P1+5,1,peek),(P1,4,5),(arg(1),4,P0),(arg(2),4,8),
                    (SP-5,1,b2),
                    (W.STUB_OVR,4,k0),(W.STUB_OVR+16,4,k1),(W.STUB_OVR+32,4,k2),
                    (W.STUB_WR,4,SP-0x10),(W.STUB_WR+4,4,cnt),(W.STUB_WR+16,4,SP-0x10),(W.STUB_WR+20,4,c2)]
                st+=[(P0+i,1,b) for i,b in enumerate(buf+b'\0')]
                SETS.append(st)
