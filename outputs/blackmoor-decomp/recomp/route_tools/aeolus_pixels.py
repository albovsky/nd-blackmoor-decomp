"""Private Aeolus planner: closed P6 framebuffer pixels only; ordinary UI candidates.
Never reads saves, process memory, guest flags, resource payloads, clocks or RNG.
The caller supplies its pinned local atlas. Runtime owns all results.
"""
from pathlib import Path
import re,json,hashlib,sys
P=Path(__file__).resolve().parent

def ppm(path):
 b=Path(path).read_bytes();m=re.match(rb'P6\s+(\d+)\s+(\d+)\s+255\s',b)
 assert m and tuple(map(int,m.groups()))==(640,480)
 pix=b[m.end():];assert len(pix)==640*480*3
 return pix

def tile(pix,r,c):
 x,y=161+45*c,19+45*r
 return b''.join(pix[((y+j)*640+x)*3:((y+j)*640+x+43)*3]for j in range(43))


def observe(path, atlas_path):
 pix=ppm(path);atlas=json.loads(Path(atlas_path).read_text())['templates'];out={};quality={}
 spaces={'player':[(r,c)for r in range(8)for c in range(5)]+[(r,c)for r in [3,4]for c in [-3,-2,-1]],'top':[(1,c)for c in range(5)],'bottom':[(7,c)for c in range(5)],'left':[(r,0)for r in range(2,7)],'right':[(r,4)for r in range(2,7)]}
 for kind,pts in spaces.items():
  mask=atlas[kind]['mask'];ranks=[]
  for r,c in pts:
   t=tile(pix,r,c);err=sum(abs(t[i*3+j]-rgb[j])for i,*rgb in mask for j in range(3))/(3*len(mask));ranks.append((round(err,3),r,c))
  ranks.sort();quality[kind]=ranks[:2];out[kind]=list(ranks[0][1:])if ranks[0][0]<4 else None
 assert out['player'] is not None,('no visible player',quality)
 out['quality']=quality;out['capture_sha256']=hashlib.sha256(Path(path).read_bytes()).hexdigest();return out

CONTROLS={'W1':(459,224,0,-1),'W2':(416,224,0,-2),'N1':(504,171,-1,0),'N2':(504,131,-2,0),'E1':(544,224,0,1),'E2':(585,224,0,2),'S1':(504,280,1,0),'S2':(504,321,2,0)}
def safe(q):
 r,c=q;return 0<=r<8 and (0<=c<5 and (r%2==0 or c in [1,3]) or r in [3,4]and -3<=c<0)
def plan(o,turn):
 r,c=o['player'];options=[];vertical=bool(o['top']or o['bottom'])
 targets=[o[k]for k in ['left','right']if o[k]]
 for name,(x,y,dr,dc)in CONTROLS.items():
  rr,cc=r+dr,c+dc
  if not safe((rr,cc)):continue
  hit=next((k for k in ['top','bottom','left','right']if o[k]==[rr,cc]),None)
  anchor=rr in [0,2,4,6]and cc in [1,3]
  vertical_safe=cc in [1,3]and rr in [0,1,2,4,6,7]
  if hit in ['top','bottom']:rank=100
  elif hit and not vertical:rank=90
  elif c<0 and rr==4 and cc<0 and cc>c:rank=70
  elif vertical and vertical_safe:
   goalrow=7 if o['bottom']else 1
   rank=60-abs(rr-goalrow)
  elif not vertical and rr%2==0 and 0<=cc<5:
   distance=min([abs(rr-a)+abs(cc-b)for a,b in targets]or[0]);rank=60-distance
  else:continue
  options.append((rank,(turn+list(CONTROLS).index(name))%8,name,[rr,cc],hit))
 if not options:raise ValueError(('no safe ordinary move candidate',o))
 options.sort(reverse=True);rank,_,name,dest,hit=options[0];x,y,*_=CONTROLS[name]
 return {'control':name,'point':[x,y],'expected_pre_wind_destination':dest,'current_visible_pickup':hit,'candidate_options':options,'basis':'pixels-only current piece/banks; ordinary arrows; safe bottom/top perimeter pursuit, then safe even-row horizontal approaches'}
