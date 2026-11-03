#!/usr/bin/env python3
"""Original Grenny crossing via ordinary input; explicit source/native profile, no hidden board reads."""
import argparse
import json
from pathlib import Path
import re
import shutil
import time
import bul_live as io
import check_route
import story_route
import grenny_profile as guard
from capture_receipts import verify_captures

HERE=Path(__file__).resolve().parent
POINTS=((517,115),(448,115),(379,115),(310,115),(241,115),(172,115),(103,115),(103,188))
MAX_ATTEMPTS=20
PICKUP_CLICKS=24
EXIT_ATTEMPTS=12


def crossing_payload():
    steps=[];t=1
    for x,y in POINTS:
        steps.extend([f'{t}:move:{x},{y}',f'{t+1000}:click:{x},{y},600',f'{t+10000}:shot:0,0']);t+=13000
    steps.append(f'{t+25000}:shot:0,0')
    return';'.join(steps)


def pickup_payload():
    pickup=[]
    for n in range(PICKUP_CLICKS):
        t=1+n*137;pickup.extend([f'{t}:move:306,182',f'{t+30}:click:306,182,80'])
    pickup.append('8500:shot:0,0')
    return';'.join(pickup)


def send(session,payload,tag):
    observation,image=session.send(payload)
    with(session.out/'decisions.jsonl').open('a')as stream:
        stream.write(json.dumps({'request':session.request_id,'tag':tag,'state':observation['state'],
          'closed_capture':image.name})+'\n')
    return observation,image


def click(session,x,y,settle,tag):
    return send(session,f'1:move:{x},{y};101:click:{x},{y},300;{settle}:shot:0,0',tag)


def save_payload(name):
    # Exact exercised Input.save timing, with the existing public name-box helper.
    tail=story_route.save_tail('unused',19000,name)
    tail=re.sub(r'unused\+(\d+)',r'\1',tail)
    return'1000:move:75,448;2000:click:75,448,1000;6000:move:275,95;7000:click:275,95,1000;'+tail


def put_and_close(session,remaining_bag):
    send_tag='ordinary-reopen-inventory-with-held8'
    click(session,212,448,2500,send_tag)
    x,y=guard.first_free_slot(remaining_bag)
    observation,image=click(session,x,y,2500,'ordinary-put8-source-derived-empty-slot')
    io.require(observation['state'][3]==-1,'normal PUT did not clear held8')
    return click(session,360,20,4000,'ordinary-close-inventory')


def play(session,source,name):
    observation,image=send(session,story_route.load_save_prefix()+';'+(HERE/'grenny-start.txt').read_text().strip(),
                            'normal-fountain-to-Grenny')
    io.require(observation['state']==[2586,2586,0,-1],'actual Grenny start differs')
    for attempt in range(1,MAX_ATTEMPTS+1):
        observation,image=send(session,crossing_payload(),'ordinary-authored-top-crossing-attempt-'+str(attempt))
        if observation['flags'].get(1978)==1:
            io.require(observation['state']==[2463,2463,0,-1],'original crossing success scene differs');break
        io.require(observation['state']==[2586,2586,0,-1],'crossing unfinished rather than authored reset')
    else:raise ValueError('20 ordinary randomized crossings unfinished; no reward/save claim')
    send(session,pickup_payload(),'ordinary-short-key8-pickup-retries-across-loop-frames')
    click(session,212,448,4000,'ordinary-inventory-after-earned-key8')
    observation,image=click(session,62,100,4000,'ordinary-select-authored-new8-first-slot')
    io.require(observation['state'][3]==8,'realheld8 not observed after original pickup')
    put_and_close(session,source['ordered_bag'])
    for exit_try in range(EXIT_ATTEMPTS):
        observation,image=send(session,f'1:move:311,355;101:click:311,355,80;{2100+17*exit_try}:shot:0,0',
                                'ordinary-short-frog-bottom-exit-'+str(exit_try+1))
        if observation['state']==[2460,2460,0,-1]:break
        io.require(observation['state']==[2463,2463,0,-1],'unknown original exit branch')
    else:raise ValueError('normal frog exit not reached within short-click bound')
    io.require(all(observation['flags'].get(f,0)==1 for f in guard.WIN),'real original success flags required before UI save')
    observation,image=send(session,save_payload(name),'original-ui-earned-key8-save')
    io.require(observation['state']==[2460,2460,0,-1],'UI save did not return to safe fountain')
    return attempt


def reload_play(session,saved_state):
    observation,image=send(session,story_route.load_save_prefix()+';S2460.CIF+16000:shot:0,0','normal-output-only-load')
    io.require(observation['state']==[2460,2460,0,-1],'reload did not reach safe fountain')
    click(session,212,448,4000,'ordinary-reload-inventory')
    x,y=guard.item_slot(saved_state,8)
    observation,image=click(session,x,y,4000,'ordinary-reload-select8-from-produced-bag')
    io.require(observation['state'][3]==8,'fresh output-only reload did not show realheld8')
    remaining=list(saved_state['ordered_bag']);remaining.remove(8)
    observation,image=put_and_close(session,remaining)
    io.require(observation['state']==[2460,2460,0,-1],'reload did not return to safe unheld fountain')


def audit(session,profile,source,*,reload=False,minimum_clock=None):
    receipt=session.receipt;log=(session.out/'run.log').read_text()
    io.require(receipt['returncode']==0 and receipt['error']is None and receipt['source_unchanged']and receipt['copy_unchanged'],
               'ordinary Session failed or source/copy changed')
    lines=(session.out/'requests.txt').read_text().splitlines();io.require(lines[-1]==f'{len(lines)} finish','explicit finish absent')
    acks=[line for line in log.splitlines()if line.startswith('  CONTROL ACK ')]
    io.require(len(acks)==len(lines)-1,'request/ACK count differs');total=[0,0]
    for n,(line,ack)in enumerate(zip(lines[:-1],acks),1):
        ident,payload=line.split(' ',1);io.require(ident==str(n),'nonsequential ordinary requests')
        values=io.ack(ack,n,len(payload.split(';')),total)
        io.require(values[3]==sum(':shot:'in s for s in payload.split(';')),'closed local-shot count differs');total=values[5:7]
    summary=io.completed(log,len(lines),total)
    io.require(summary==receipt['control_summary']and int(re.search(r' bytes=(\d+) ',summary)[1])==(session.out/'requests.txt').stat().st_size,
               'control completion/bytes differ')
    results=[line for line in log.splitlines()if line.startswith('RESULT ')]
    io.require(len(results)==1 and re.match(r'RESULT \{\s*"stopped"\s*:\s*"stop requested(?: |")',results[0]),'normal own requested stop absent')
    io.require(re.search(r'FILE open .*\\'+re.escape(session.source.name)+r'\s+\[virtual \d+ ms\]',log),'genuine sole source not opened')
    opened={int(n)for n in re.findall(r'FILE open .*?\\S(\d+)\.CIF',log,re.I)}
    io.require(not({6301,1232,1261,1206,3588,3595}&opened),'unrelated failure/puzzle branch reached')
    if not reload:io.require({2586,2580,2462,2463,2460}<=opened,'authored crossing/movie/reward chain missing')
    captures=verify_captures(session.out,receipt['captures'],total[1])
    observations=session.observations;io.require(observations and any(o['state'][3]==8 for o in observations),'actualheld8 observation missing')
    clocks=[]
    for observation in observations:
        flags=observation['flags'];scope=check_route.flag_scope(observation['scope'],include_clock=True)
        io.require(guard.LIVE|set(range(338,342))<=scope,'focused observations incomplete')
        changing=guard.WIN
        expected=guard.expected_output(source)['flags']if reload else source['flags']
        io.require(all(flags.get(f,0)==expected[str(f)]for f in guard.LIVE-changing),'inherited optional/prerequisite event changed')
        clocks.append((scope&set(range(338,342)),{'total_minutes':(flags.get(338,0)>>16)|((flags.get(339,0)&65535)<<16),
          'minute':flags.get(339,0)>>16,'hour':flags.get(340,0)&65535,'day':flags.get(340,0)>>16}))
    check_route.verify_clock_diagnostics(clocks)
    io.require(guard.clock_total(clocks[0][1])>=guard.clock_total(minimum_clock or source['clock']),'live clock predates source')
    io.require(observations[-1]['state']==[2460,2460,0,-1]and all(observations[-1]['flags'].get(f,0)==1 for f in guard.WIN),
               'final original safe win absent')
    guard.check_data(session.game,profile['data_pins'],runtime_saves=True)
    return {'control_summary':summary,'steps':total[0],'closed_shots':total[1],'capture_catalog':captures,
      'normal_result':results[0],'realheld8_observed':True,'log_sha256':io.digest(session.out/'run.log'),
      'requests_sha256':io.digest(session.out/'requests.txt')}


def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__)
    for name in('native','game-exe','game-data','source-save','profile','output'):p.add_argument('--'+name,type=Path,required=True)
    p.add_argument('--profile-name',choices=tuple(guard.PROFILE_DIFFICULTIES),default='junior-grenny',
                   help='expected original difficulty profile; the saved mode is never changed')
    p.add_argument('--native-sha256',required=True);p.add_argument('--save-sha256',required=True)
    p.add_argument('--save-name',default='m65');p.add_argument('--timeout',type=int,default=300)
    args=p.parse_args(argv);active=None;created_output=False;receipt={'accepted':False,'no_historical_SAV_runtime_input':True}
    try:
        io.require(1<=args.timeout<=300 and re.fullmatch('[a-z0-9]{1,10}',args.save_name),'bounded timeout/lowercase UI filename required')
        for name in('native','game_exe','game_data','source_save','profile'):setattr(args,name,getattr(args,name).resolve(strict=True))
        profile=guard.read(args.profile,profile_name=args.profile_name)
        io.require(args.native_sha256==profile['native_sha256']==io.digest(args.native)and args.save_sha256==profile['source_sha256'],
                   'explicit native/source/profile pin differs')
        io.require(io.digest(args.game_exe)==io.digest(args.game_data/'GAME.EXE')==io.ORIGINAL_SHA256,'immutable original differs')
        io.require(args.source_save.name.lower()!=args.save_name+'.sav','new output name equals source')
        source=guard.source_state(args.source_save,profile,profile_name=args.profile_name)
        io.require(not(args.game_data/'Documents5').exists()and not any(p.is_symlink()for p in args.game_data.rglob('*')),'seed has saves/symlinks')
        guard.check_data(args.game_data,profile.get('data_pins'))
        io.require(isinstance(profile.get('origin_receipts'),list)and profile['origin_receipts'],'accepted source origin pins required')
        for item in profile['origin_receipts']:io.require(io.digest(Path(item['path']))==item['sha256'],'origin receipt changed')
        origin=json.loads(Path(profile['origin_receipts'][0]['path']).read_text())
        io.require(origin['accepted']is True and origin['protected_inputs_unchanged']is True and origin['original_NewGame_origin_preserved']is True
                   and origin['native_sha256']==args.native_sha256 and Path(origin['final_checkpoint']).resolve()==args.source_save
                   and origin['stages'][-1]['output_sha256']==args.save_sha256,
                   'source is not the accepted own current-native NewGame/fresh-reload checkpoint')
        out=args.output.resolve();io.require(not out.exists()and args.game_data not in out.parents and args.source_save.parent not in out.parents
           and out!=args.game_data and out!=args.source_save.parent,'new independent output required')
        protected={str(p):io.digest(p)for p in(args.native,args.game_exe,args.source_save,args.profile,Path(__file__),
          Path(guard.__file__),Path(io.__file__),Path(check_route.__file__),Path(story_route.__file__),HERE/'capture_receipts.py',HERE/'grenny-start.txt')}
        protected.update({str(args.game_data/rel):digest for rel,digest in profile['data_pins'].items()})
        protected.update({item['path']:item['sha256']for item in profile['origin_receipts']})
        out.mkdir(parents=True,exist_ok=False);created_output=True;receipt.update(native_sha256=args.native_sha256,source_sha256=args.save_sha256,
          source_state=source,profile_name=args.profile_name,protected_inputs=protected,policy='v4 fixed ordinary crossing;20authored attempts/24pickup/12exits',
          original_NewGame_origin_preserved=True)
        io.write_json(out/'receipt.json',receipt)
        flags=','.join(map(str,sorted(guard.LIVE|set(range(338,342)))))
        active=producer=io.Session(args,out/'producer',args.source_save,rc_flags=flags);error=None
        try:attempts=play(producer,source,args.save_name)
        except(Exception,KeyboardInterrupt)as exc:error=str(exc)or type(exc).__name__
        finally:producer.close(error)
        producer_audit=audit(producer,profile,source)
        saved=producer.saves/(args.save_name+'.SAV');saved_state=guard.check_output(guard.snapshot(saved,profile['flags']),source)
        io.require(set(p.name for p in producer.saves.glob('*.SAV'))<={args.source_save.name,saved.name,'HICONTINUECHEAT.SAV'},'unexpected producer save')
        saved_sha=io.digest(saved);io.require(re.search(r'FILE open .*\\'+re.escape(saved.name)+r'\s+\[virtual \d+ ms\]',(producer.out/'run.log').read_text()),'original UI output never opened')
        active=reload=io.Session(args,out/'reload',saved,rc_flags=flags);error=None
        try:reload_play(reload,saved_state)
        except(Exception,KeyboardInterrupt)as exc:error=str(exc)or type(exc).__name__
        finally:reload.close(error)
        reload_audit=audit(reload,profile,source,reload=True,minimum_clock=saved_state['clock'])
        io.require({p.name:io.digest(p)for p in reload.saves.glob('*.SAV')}=={saved.name:saved_sha},'not fresh-only unchanged output reload')
        guard.check_output(guard.snapshot(reload.copy,profile['flags']),source)
        target=out/saved.name;shutil.copy2(saved,target);io.require(io.digest(target)==saved_sha,'accepted save copy differs')
        receipt.update(accepted=True,output_save=str(target),output_save_sha256=saved_sha,saved_state=saved_state,
          producer=producer_audit,reload=reload_audit,authored_crossing_attempts=attempts,authored_losses=attempts-1)
    except(Exception,KeyboardInterrupt)as exc:
        receipt['error']=str(exc)or type(exc).__name__
        if active is not None and active.proc.poll()is None:
            try:active.close(receipt['error'])
            except Exception:pass
    finally:
        if 'protected'in locals():
            receipt['protected_inputs_unchanged']=all(io.digest(Path(path))==digest for path,digest in protected.items())
            if not receipt['protected_inputs_unchanged']:receipt['accepted']=False
        if created_output:io.write_json(out/'receipt.json',receipt)
    print(json.dumps({'accepted':receipt['accepted'],'error':receipt.get('error'),'output':receipt.get('output_save')},indent=2))
    return 0 if receipt['accepted']else 1


if __name__=='__main__':raise SystemExit(main())
