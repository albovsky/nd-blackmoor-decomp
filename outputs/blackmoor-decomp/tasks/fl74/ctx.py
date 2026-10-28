"""ctx.py FUNC JUMP [N]: linear disassembly from FUNC, print the N instructions up to and including JUMP"""
import sys; sys.path.insert(0,'/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp/tasks/fl73/tools')
import disx
f=int(sys.argv[1],16); j=int(sys.argv[2],16); n=int(sys.argv[3]) if len(sys.argv)>3 else 10
ins=list(disx.md.disasm(disx.rd(f,j-f+16),f))
idx=[k for k,i in enumerate(ins) if i.address==j]
if not idx: print('jump not on linear path'); sys.exit()
k=idx[0]
for i in ins[max(0,k-n):k+1]: print('%x: %s %s'%(i.address,i.mnemonic,i.op_str))
