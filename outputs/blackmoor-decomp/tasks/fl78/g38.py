import itertools
SETS=[]
bufs=[b'\r\n',b'ab\r\n',b'a\r',b'\r',b'\x1a',b'x\x1ay',b'\r\r\n',b'\r\nab',b'ab\r']
for fl,peek in ((0x80,0xa),(0x80|0x08,0x41),(0x80|0x40,0),(0x80|0x48,0xa),(0x80|0x08,0xa),(0x80,0),(0x48,0x41)):
    for buf in bufs:
        for cnt in (len(buf),len(buf)+1):
          for r1,r2,e2 in ((1,1,0),(1,0,0),(1,0,7),(1,1,5)):
            for c2 in (0,1):
                st=[(arg(0),4,0),(0x63cde0,4,P1),(P1+4,1,fl),(P1+5,1,peek),(P1,4,5),(arg(1),4,P0),(arg(2),4,8),
                    (SP-5,1,[0xa,0x41,0xd][c2]),
                    (W.STUB_OVR,4,r1),(W.STUB_OVR+16,4,r2),(W.STUB_OVR+32,4,e2),
                    (W.STUB_WR,4,SP-0x10),(W.STUB_WR+4,4,cnt),(W.STUB_WR+16,4,SP-0x10),(W.STUB_WR+20,4,c2)]
                st+=[(P0+i,1,b) for i,b in enumerate(buf+b'\0')]
                SETS.append(st)
