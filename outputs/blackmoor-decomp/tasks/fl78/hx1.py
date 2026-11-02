import json,itertools,sys
sys.path.insert(0,'tests')
import fl41_world as W
SP=W.SP; STOP=W.STOP
EF=W.EFLAGS_OVERRIDE; FC=W.FCW_OVERRIDE; ST=W.ST_OVERRIDE
row=sys.argv[1]; out=sys.argv[2]
S=[]
seed=0
for zf in (0,0x40):
 for fcw in (0x27f,0x37f):
  for hi in (0,0x80000000,0x3ff00000,0xbff00000,0x7ff00000,0xfff00000,0x7ff80000,0x00000001,0x80000001,0x000fffff,0x400921fb):
   for lo in (0,1,0x54442d18):
    for st0 in (None,0):
     for g in (0,1):
      ov=[[SP,4,STOP],[SP+4,4,lo],[SP+8,4,hi],[EF,4,zf],[FC,4,fcw],[0x63ca04,4,g]]
      if st0 is not None: ov.append([ST,8,st0])
      S.append([seed%7+1,ov]); seed+=1
json.dump({row:S},open(out,'w'))
print(len(S))
