"""Bounded caller-pinned Aeolus playthrough. Only FIFO ordinary UI input + actual PPM pixels.
No guest memory, callbacks, RNG, clock, puzzle state, or save mutation.
"""
from pathlib import Path
from bul_live import ack, completed, ORIGINAL_SHA256
import os,sys,time,json,hashlib,subprocess,shutil,re,runpy,traceback
P=Path(__file__).resolve().parent
sha=lambda f:hashlib.sha256(Path(f).read_bytes()).hexdigest()
LOAD='MAIN.CIF+1400:move:275,95;MAIN.CIF+2400:click:275,95,800;MAIN.CIF+9000:move:300,105;MAIN.CIF+10000:click:300,105,800;MAIN.CIF+14000:move:553,248;MAIN.CIF+15000:click:553,248,800;MAIN.CIF+20000:shot:0,0'
from aeolus_ppm import convert as CONVERT

class Session:
 def __init__(self,out,source,source_sha,rc_flags,*,runtime):
  SOURCE,SOURCE_SHA=Path(source).resolve(),source_sha
  HOST,HOST_SHA=runtime.native,runtime.native_sha256
  EXE,EXE_SHA=runtime.game_exe,ORIGINAL_SHA256
  self.source,self.source_sha=SOURCE,SOURCE_SHA
  assert sha(HOST)==HOST_SHA and sha(EXE)==EXE_SHA and sha(SOURCE)==SOURCE_SHA
  self.out=Path(out);self.out.mkdir();self.game=self.out/'game'
  subprocess.run(['cp','-cR',str(runtime.game_data),str(self.game)],check=True,timeout=30)
  self.saves=self.game/'Documents5/The Curse of Blackmoor Manor';self.saves.mkdir(parents=True)
  assert not list(self.saves.glob('*.SAV'));shutil.copy2(SOURCE,self.saves/SOURCE.name)
  self.fifo=self.game/'ordinary-input.fifo';os.mkfifo(self.fifo,0o600);self.fd=os.open(self.fifo,os.O_RDWR|os.O_NONBLOCK)
  self.requests=(self.out/'requests.txt').open('w');self.events=(self.out/'controller-events.jsonl').open('w')
  self.started=time.monotonic();self.id=0;self.acks={};self.obs=[];self.partial='';self.reader=None;self.proc=None;self.finished=False;self.pending=False;self.total=[0,0]
  self.receipt={'native_authority':'caller-pinned; combined save/reload receipt applies only to this invocation','host':str(HOST),'host_sha256':HOST_SHA,'original_sha256':EXE_SHA,'source_save':str(SOURCE),'source_save_sha256':SOURCE_SHA,'copied_save_sha256':sha(self.saves/SOURCE.name),'game_dir':str(self.game),'fifo':str(self.fifo),'fifo_mode':oct(self.fifo.stat().st_mode&0o777),'controller_sha256':sha(__file__),'planner_scope':'Aeolus-only outer controller; detector/planner pinned separately','max_batches':256,'outer_timeout_seconds':300,'RC_FLAGS':rc_flags}
  (self.out/'session-source.py').write_text(Path(__file__).read_text());(self.out/'receipt.json').write_text(json.dumps(self.receipt,indent=2)+'\n')
  env=dict(os.environ);env.pop('INPUT',None);env.pop('RC_REAL',None);env.pop('RC_CONTROL_FIFO',None);env.pop('RC_TRACE_MS',None)
  env.update(GAME_EXE=str(EXE),RC_GAMEDIR=str(self.game),RC_OUT=str(self.out),RC_CONTROL_FIFO=str(self.fifo),RC_FLAGS=self.receipt['RC_FLAGS'],MAX_IMPORTS='90000000',MAX_IDLE_POLLS='3600000')
  self.stdout=(self.out/'stdout.txt').open('w')
  try:self.proc=subprocess.Popen([str(HOST)],env=env,stdout=self.stdout,stderr=subprocess.STDOUT)
  except Exception:
   self.stdout.close();self.requests.close();self.events.close();os.close(self.fd)
   raise
 def event(self,kind,**kw):
  self.events.write(json.dumps(dict(kind=kind,elapsed_seconds=round(time.monotonic()-self.started,6),**kw))+'\n');self.events.flush()
 def read_log(self):
  if self.reader is None:
   f=self.out/'run.log'
   if not f.exists():return
   self.reader=f.open()
  data=self.reader.read()
  if not data:return
  self.partial+=data;lines=self.partial.split('\n');self.partial=lines.pop()
  for line in lines:
   if line.startswith('  RC_FLAGS '):self.scope=line[11:]
   m=re.match(r'  SHOT (\d+) at virtual (\d+) ms$',line)
   if m:self.last_shot,self.clock=map(int,m.groups())
   m=re.match(r'  STATE requested_scene=(\d+) art_scene=(\d+) view=(-?\d+) held_item=(-?\d+)$',line)
   if m:self.state=list(map(int,m.groups()))
   if line.startswith('  FLAGS'):
    if len(line.encode())>=1023:raise ValueError('FLAGS may be truncated')
    flags={int(k):int(v)for k,v in re.findall(r'(\d+)=(-?\d+)',line)}
    self.obs.append({'shot':getattr(self,'last_shot',None),'clock_ms':getattr(self,'clock',None),'state':getattr(self,'state',None),'flags':flags,'scope':getattr(self,'scope','')});self.event('observation',observation=self.obs[-1])
   m=re.match(r'  CONTROL ACK id=(\d+) steps=(\d+)/(\d+) shots=(\d+) clock_ms=(\d+) total_steps=(\d+) total_shots=(\d+)$',line)
   if m:
    vals=list(map(int,m.groups()));self.acks[vals[0]]=vals;self.event('ack',values=vals)
   if line.startswith('  CONTROL ERROR'):raise RuntimeError(line)
 def send(self,payload,tag):
  assert self.id<255 and payload.isascii() and '\n'not in payload and '\r'not in payload and 0<len(payload.encode())<=65536 and len(payload.split(';'))<=512
  self.id+=1;self.pending=True;line=f'{self.id} {payload}\n';self.requests.write(line);self.requests.flush();self.event('request',id=self.id,tag=tag,steps=len(payload.split(';')))
  remaining=line.encode();started_shots=self.total[1]
  while remaining:
   try:
    n=os.write(self.fd,remaining)
    if n<=0:raise OSError('FIFO write made no progress')
    remaining=remaining[n:]
   except BlockingIOError:
    self.read_log()
    if time.monotonic()-self.started>300:raise TimeoutError('controller FIFO write deadline')
    if self.proc.poll() is not None:raise RuntimeError('native exited during FIFO write')
    time.sleep(.001)
  while self.id not in self.acks:
   self.read_log()
   if time.monotonic()-self.started>300:raise TimeoutError('controller outer deadline')
   if self.proc.poll() is not None:raise RuntimeError('native exited before ACK '+str(self.id))
   time.sleep(.001)
  values=self.acks[self.id]
  wire='  CONTROL ACK id=%d steps=%d/%d shots=%d clock_ms=%d total_steps=%d total_shots=%d'%tuple(values)
  values=ack(wire,self.id,len(payload.split(';')),self.total)
  assert values[3]>0 and values[6]>started_shots and self.obs[-1]['shot']==values[6]
  self.total=values[5:7];self.pending=False
  image=self.out/'frames'/('shot%03d.ppm'%values[6]);assert image.is_file()
  return self.obs[-1],image
 def numeric(self,items):
  return ';'.join(f'{t}:{kind}:{args}'for t,kind,args in items)
 def shot(self,delay=2000,tag='settle'):
  return self.send(f'1:move:635,385;{delay}:shot:0,0',tag)
 def click(self,x,y,settle=2500,tag='ordinary-click'):
  return self.send(f'1:move:{x},{y};101:click:{x},{y},300;{settle}:shot:0,0',tag)
 def finish(self):
  if self.finished:return
  if self.pending:raise RuntimeError('pending batch cannot finish successfully')
  assert self.id<256
  self.id+=1;line=f'{self.id} finish\n';self.requests.write(line);self.requests.flush();os.write(self.fd,line.encode());self.event('finish',id=self.id)
  self.proc.wait(timeout=20);self.read_log();self.finished=True
  if self.proc.returncode!=0:raise RuntimeError('native did not exit normally')
  completed((self.out/'run.log').read_text(),self.id,self.total)
 def close(self,outcome,error=None):
  try:
   if self.proc and self.proc.poll() is None:self.finish()
  except Exception as e:
   error=error or repr(e);self.event('finish-error',error=str(e))
   if self.proc and self.proc.poll() is None:self.proc.terminate();self.proc.wait(timeout=10)
  self.receipt.update(outcome=outcome,error=error,returncode=self.proc.returncode if self.proc else None,seconds=round(time.monotonic()-self.started,3),saves={f.name:sha(f)for f in self.saves.glob('*.SAV')},observations=self.obs)
  self.requests.close();self.events.close();self.stdout.close();os.close(self.fd)
  if self.reader:self.reader.close()
  log=(self.out/'run.log').read_text();summary=re.findall(r'(?m)^  CONTROL SUMMARY (.*)$',log)
  protocol_complete=False
  if self.finished and self.proc.returncode==0 and not error:
   try:completed(log,self.id,self.total);protocol_complete=True
   except ValueError as failure:error=repr(failure)
  self.receipt.update(error=error,protocol_complete=protocol_complete,source_unchanged=sha(self.source)==self.source_sha,copied_source_unchanged=sha(self.saves/self.source.name)==self.source_sha,control_summary=summary[-1]if summary else None,requests_sha256=sha(self.out/'requests.txt'),log_sha256=sha(self.out/'run.log'))
  (self.out/'receipt.json').write_text(json.dumps(self.receipt,indent=2)+'\n')
  for f in sorted((self.out/'frames').glob('shot*.ppm')):CONVERT(f)
  print(json.dumps({k:self.receipt.get(k)for k in ['outcome','error','returncode','seconds','saves','control_summary']},indent=2),flush=True)
