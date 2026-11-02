import json,sys,itertools
sys.path.insert(0,'tests')
import fl41_world as W
SP=W.SP; STOP=W.STOP
EF=W.EFLAGS_OVERRIDE; FC=W.FCW_OVERRIDE; ST=W.ST_OVERRIDE; REG=W.REG_OVERRIDE
row=sys.argv[1]; out=sys.argv[2]
sts=[(0,0),(0x7ff8000000000000,0),(0,0x7ff8000000000000),(0x8000000000000000,0),(0x0010000000000000,0x0000000000000001),(0x7ff0000000000000,0)]
eaxs=(0,0x3fefffff,0x3ff00000,0x3ff00001,0x7ff00000,0x80000000,0xbff00000,1)
S=[]
n=0
for zf in (0,0x40):
 for fcw in (0x27f,0x37f):
  for s0,s1 in sts:
   for eax in eaxs:
    for lo,hi in ((0,0),(0,0x80000000),(5,0),(0,1),(0,0x3ff00000),(0,0x7ff00000)):
     for g in (0,1):
      ov=[[SP,4,STOP],[SP+4,4,lo],[SP+8,4,hi],[EF,4,zf],[FC,4,fcw],[0x63ca04,4,g],[REG,4,eax],[ST,8,s0],[ST+16,8,s1]]
      S.append([n%5+1,ov]); n+=1
json.dump({row:S},open(out,'w'))
print(len(S))
