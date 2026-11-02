import json,sys
sys.path.insert(0,'tests')
import fl41_world as W
SP=W.SP; STOP=W.STOP; R=lambda i: W.REG_OVERRIDE+4*i
B=0x20070000+0x2000
S=[]; n=0
sts=[0,0x8000000000000000,0x0000000000000001,0x7ff0000000000000,0xfff0000000000000,0x7ff8000000000000,0x3ff0000000000000,0x0010000000000000,0x7fe0000000000000,0x0008000000000000]
for al in (0,0xff,0xfe,5):
 for st0 in sts:
  for st1 in (0,0x7ff8000000000000,0x3ff0000000000000):
   for cwlo in (0,0x20):
    for sw in (0,0x20):
     for g in (0,1):
      ov=[[SP,4,STOP],[R(6),4,B],[B-0x90,1,al],[B-0xa4,2,cwlo],[0x63ca04,4,g],[W.ST_OVERRIDE,8,st0],[W.ST_OVERRIDE+16,8,st1],[W.FPSW_OVERRIDE,4,sw],[B-0x94,4,3]]
      S.append([n%5+1,ov]); n+=1
json.dump({sys.argv[1]:S},open(sys.argv[2],'w')); print(len(S))
