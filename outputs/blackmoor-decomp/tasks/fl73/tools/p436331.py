import sys; sys.path.insert(0,sys.argv[0].rsplit('/',1)[0])
from drv import *
import unicorn,struct
key='0x435015'
pool,W,G,row=setup(key)
W.INSTRUCTION_LIMIT=600000
scen=F.known_scenarios(key,F.POOLS[pool]['world'],sys.argv[1:])
n=0
for s,ov in scen:
    seen=[]
    def watch(uc,ensure,trace,sp):
        def h(uc_,a,sz,u):
            from unicorn.x86_const import UC_X86_REG_ESI,UC_X86_REG_ECX,UC_X86_REG_EDX
            esi=uc_.reg_read(UC_X86_REG_ESI);ecx=uc_.reg_read(UC_X86_REG_ECX)
            try: b=bytes(uc_.mem_read(esi,16))
            except Exception as e: b=b''
            seen.append((hex(esi),hex(ecx),b.hex()))
        uc.hook_add(unicorn.UC_HOOK_CODE,h,begin=0x43633d,end=0x43633d)
    t=W.run_original(row,s,[tuple(o) for o in ov],watch=watch)
    if seen: print(s,t.fault,seen[:2]); n+=1
    if n>6: break
