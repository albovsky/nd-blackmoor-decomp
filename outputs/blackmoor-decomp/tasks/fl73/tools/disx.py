import sys,struct,capstone
d=open('/home/user/nd-blackmoor-decomp/work/original/GAME.EXE','rb').read()
pe=struct.unpack_from('<I',d,0x3c)[0]
ns=struct.unpack_from('<H',d,pe+6)[0]; osz=struct.unpack_from('<H',d,pe+20)[0]
secs=[]
for i in range(ns):
    o=pe+24+osz+40*i
    vs,va,rs,rp=struct.unpack_from('<IIII',d,o+8)
    secs.append((va+0x400000,vs,rp,rs))
def rd(va,n):
    for a,vs,rp,rs in secs:
        if a<=va<a+max(vs,rs): return d[rp+va-a:rp+va-a+n]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
if __name__=='__main__':
    a=int(sys.argv[1],16);n=int(sys.argv[2],16)
    for i in md.disasm(rd(a,n),a): print('%x: %s %s'%(i.address,i.mnemonic,i.op_str))
