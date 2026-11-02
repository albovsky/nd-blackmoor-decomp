#!/usr/bin/env python3
"""Bounded ordinary-input Jane Memory play, with explicit source profiles.

Reuses bul_live.Session/PPM/INPUT transport and captured exposed faces only.
The original alone deals, scores, decides outcomes and serializes saves.
Probe stops at Jane's actual later list; solve requires a caller-pinned,
observed ordinary entry. Post-win Bye uses actual pixels and bounded stdin.
"""
import argparse
import json
from pathlib import Path
import re
import select
import sys
import time

import bul_live as io
import story_route
import memory_pixels as pixels
import memory_profile as profiles

SCOPE = '338-341,1335,1345,1357,1361,1404-1405,1567,1791,1865,1980,1988,2001,2017,2072'
MAX_REQUESTS = 96
MAX_POSTWIN_BATCHES = 16
ASSET_SHA = {
    'GAME.EXE': io.ORIGINAL_SHA256,
    'Game.ini': 'f8f892e828eca6086f5a25720e5e8e0c2ebbb7d81f1bb90bb8b73ea244419c79',
    'Ciftree/CIFTREE.DAT': '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161',
    'Ciftree/boot.CIF': 'e3a0e0e352112f73cbfc24d0f0dabd34542d98e5d2875428b98ad5db4f4786b4',
    'Ciftree/convo.CIF': 'ac3414e977dbe36409e683a797c5ecfa2b4b270f915dcddc3872053763e37cde',
}
EMBEDDED_SCENES = {3510, *range(1200,1210), 1216, 1217, 1268, 1993, 1994, *range(1290,1294)}


def source_state(path, profile):
    return profiles.source_state(path, profile)


def validate_payload(payload, limit=512):
    steps = payload.split(';')
    io.require(0 < len(steps) <= limit and payload.isascii() and len(payload.encode()) <= 65536
               and '\n' not in payload and '\r' not in payload, 'ordinary INPUT bounds differ')
    for step in steps:
        m = re.fullmatch(r'(?:[A-Za-z0-9_.]+\+)?\d+:(move|click|pointer|key|shot):([0-9,-]+)', step)
        io.require(m is not None, 'only ordinary shared INPUT events are accepted')
        kind, raw = m.groups()
        args = [int(v) for v in raw.split(',')]
        if kind == 'key':
            io.require(len(args) == 1 and 0 <= args[0] <= 255, 'invalid ordinary key')
        elif kind == 'shot':
            io.require(args == [0,0], 'invalid capture request')
        else:
            io.require(len(args) == (3 if kind in ('click','pointer') else 2)
                       and 0 <= args[0] < 640 and 0 <= args[1] < 480, 'pointer coordinates differ')
            if kind == 'click':
                io.require(1 <= args[2] <= 6000, 'click hold outside bounded ordinary UI range')
            if kind == 'pointer':
                io.require(0 <= args[2] <= 3, 'invalid ordinary button mask')
    return payload


def talk_probe():
    # No reply coordinates are selected; first actual later list must be read.
    return ('S3510.CIF+12000:move:312,233;S3510.CIF+13000:click:312,233,600;'
            'S3510.CIF+50000:move:635,385;S3510.CIF+51000:shot:0,0')


def send(session, payload):
    io.require(session.request_id < MAX_REQUESTS - 1, 'request budget exhausted; finish reserved')
    return session.send(validate_payload(payload))


def capture_record(session, observation, image, **values):
    io.write_json(session.out / f'memory-capture-{len(session.observations):03d}.json',
                  dict(capture=image.name, capture_sha256=io.digest(image), observation=observation, **values))


def is_board(observation):
    return observation['state'] == [1206,1206,0,-1]


def earned(observation):
    return observation['flags'].get(1345, 0) == 1


def play_board(session, entry):
    observation, image = send(session, story_route.load_save_prefix() + ';' + entry)
    io.require(is_board(observation) and observation['flags'].get(1335) == 1
               and observation['flags'].get(1345,0) == 0, 'observed entry did not reach a new selected-profile Memory board')
    memory = pixels.FaceMemory(io.ppm(image))
    submitted_attempts = 0
    capture_record(session, observation, image, stage='initial captured backs; no hidden deal read')

    def pair(first, second):
        nonlocal observation, image, submitted_attempts
        observation, image = send(session, pixels.flip_payload(first))
        io.require(is_board(observation), 'unexpected transition before second selection')
        memory.reveal(io.ppm(image), first)
        capture_record(session, observation, image, stage='first exposed face', card=first)
        submitted_attempts += 1
        io.require(submitted_attempts <= 24, 'bounded ordinary pair attempts exhausted')
        observation, image = send(session, pixels.flip_payload(second))
        capture_record(session, observation, image, stage='second face/outcome', cards=[first,second])
        if not is_board(observation):
            # The guest may finish before a final face capture. Never infer win
            # from pixel predictions, attempted pairs, elapsed time or ACK.
            observation, image = send(session, '1:move:635,385;12001:shot:0,0')
            io.require(earned(observation), 'natural loss or unknown outcome; no retry/save accepted')
            return True
        same = memory.pair(first, second, io.ppm(image))
        observation, image = send(session, pixels.settle_payload())
        if not is_board(observation):
            observation, image = send(session, '1:move:635,385;12001:shot:0,0')
            io.require(earned(observation), 'natural loss or unknown outcome after ordinary settling')
            return True
        memory.settled(io.ppm(image), first, second, same)
        capture_record(session, observation, image, stage='normal settled board', attempts=memory.attempts,
                       remembered={str(k):v for k,v in memory.labels.items()}, matched=sorted(memory.matched))
        return False

    for first in range(0,24,2):
        if pair(first,first+1):
            return observation, image, submitted_attempts
    for first,second in memory.recalled_pairs():
        if pair(first,second):
            return observation, image, submitted_attempts
    observation, image = send(session, '1:move:635,385;12001:shot:0,0')
    io.require(earned(observation), 'all predicted pairs do not prove a guest win')
    return observation, image, submitted_attempts


def report(observation, image):
    print(json.dumps({'state':observation['state'], 'flags':observation['flags'],
                      'closed_ppm':str(image), 'sha256':io.digest(image)}), flush=True)


def postwin_exit(session, observation, image):
    io.require(earned(observation), 'post-win ordinary control requires a real new1345')
    report(observation, image)
    print('POSTWIN: supply ordinary JSON batch commands from actual list pixels; {"save":true} only after safe3510/view4/held-1.', flush=True)
    for _ in range(MAX_POSTWIN_BATCHES):
        while not select.select([sys.stdin], [], [], .05)[0]:
            io.require(session.proc.poll() is None and time.monotonic()-session.started < session.args.timeout,
                       'bounded post-win input deadline; no checkpoint accepted')
        line = sys.stdin.readline()
        io.require(bool(line), 'post-win operator stream closed')
        command = json.loads(line)
        if command.get('save'):
            io.require(observation['state'] == [3510,3510,4,-1] and earned(observation),
                       'normal room return is required before original UI Save')
            return
        payload = validate_payload(command['batch'], limit=32)
        observation, image = send(session, payload)
        io.require(earned(observation), 'durable Memory result disappeared')
        report(observation, image)
    raise ValueError('bounded post-win ordinary batches exhausted; no accepted save')


def save_payload(name):
    io.require(re.fullmatch(r'[a-z0-9]{1,10}', name) is not None and name != 'continue', 'invalid new original UI save name')
    text = story_route.menu_to_save_screen('unused',1000) + ';' + story_route.save_tail('unused',19000,name)
    return re.sub(r'unused\+(\d+)', r'\1', text)


def output_state(path, source):
    return profiles.output_state(path, source)


def main(argv=None):
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--mode', choices=('probe','solve'), default='probe')
    for field in ('native','game-exe','game-data','source-save','output'):
        p.add_argument('--'+field, type=Path, required=True)
    p.add_argument('--source-profile', type=Path, required=True)
    p.add_argument('--native-sha256', required=True)
    p.add_argument('--entry-input', type=Path)
    p.add_argument('--entry-sha256')
    p.add_argument('--save-name', default='mem1')
    p.add_argument('--timeout', type=int, default=300)
    args = p.parse_args(argv)
    io.require(re.fullmatch(r'[0-9a-f]{64}',args.native_sha256) is not None, 'explicit native SHA-256 required')
    io.require(1 <= args.timeout <= 300, 'bounded timeout required')
    for field in ('native','game_exe','game_data','source_save','source_profile'):
        setattr(args, field, getattr(args, field).resolve(strict=True))
    io.require(io.digest(args.native) == args.native_sha256, 'explicit native pin differs')
    io.require(io.digest(args.game_exe) == io.digest(args.game_data/'GAME.EXE') == io.ORIGINAL_SHA256,
               'original image pin differs')
    io.require(not (args.game_data/'Documents5').exists()
               and not any(q.is_symlink() for q in args.game_data.rglob('*')), 'seed contains saves/symlinks')
    io.require(all(io.digest(args.game_data/rel)==h for rel,h in ASSET_SHA.items()), 'effective original asset/configuration pin differs')
    loose = {q.name.casefold() for q in (args.game_data/'Ciftree').iterdir()}
    io.require(not ({f's{n}.cif' for n in EMBEDDED_SCENES} | {'font.cif'}) & loose,
               'unexpected loose scene/font override; static entry map no longer applies')
    io.require(re.fullmatch(r'[a-z0-9]{1,10}',args.save_name) is not None and args.save_name != 'continue' and args.source_save.name.lower() != args.save_name+'.sav', 'new canonical UI name must differ from source/reserved name')
    profile = profiles.load(args.source_profile)
    source = source_state(args.source_save, profile)
    target = args.output.resolve()
    io.require(not target.exists() and args.game_data not in target.parents
               and args.source_save.parent not in target.parents, 'new private output required outside originals/source')
    entry = None
    if args.mode == 'solve':
        io.require(args.entry_input is not None and args.entry_sha256 is not None
                   and io.digest(args.entry_input) == args.entry_sha256, 'solve needs a frozen observed entry transcript')
        entry = validate_payload(args.entry_input.read_text().strip())
    target.mkdir(parents=True)
    protected = {str(q):io.digest(q) for q in [args.native,args.game_exe,args.source_save,
                  *(args.game_data/rel for rel in ASSET_SHA),Path(__file__),Path(pixels.__file__),
                  Path(io.__file__),Path(story_route.__file__),Path(profiles.__file__),args.source_profile,
                  *([args.entry_input] if entry is not None else [])]}
    receipt = {'accepted':False,'mode':args.mode,'native_sha256':args.native_sha256,'source_sha256':profile['source_sha256'],
               'source_profile':profile,'source_profile_sha256':io.digest(args.source_profile),
               'source_state':source,'protected_inputs':protected,'scope':'one explicit genuine source profile; no all-deal or whole-game claim'}
    io.write_json(target/'receipt.json', receipt)
    producer = io.Session(args,target/'producer',args.source_save,rc_flags=SCOPE)
    error = None
    try:
        if args.mode == 'probe':
            observation,image = send(producer,story_route.load_save_prefix()+';'+talk_probe())
            io.require(observation['state'][:2] == [1200,1200] and not earned(observation),
                       'probe did not reach the expected unsolved later Jane list')
            report(observation,image)
        else:
            observation,image,attempts = play_board(producer,entry)
            postwin_exit(producer,observation,image)
            observation,image = send(producer,'1:move:635,385;8001:shot:0,0;12001:shot:0,0')
            io.require(observation['state'] == [3510,3510,4,-1] and earned(observation), 'post-Bye normal settling did not remain safe')
            observation,image = send(producer,save_payload(args.save_name))
            io.require(observation['state'] == [3510,3510,4,-1] and earned(observation), 'UI save did not return safely')
            receipt['estimated_capture_attempts'] = attempts
    except (Exception, KeyboardInterrupt) as exc:
        error = str(exc) or type(exc).__name__
    finally:
        try:
            producer.close(error)
        except (Exception,KeyboardInterrupt) as exc:
            error = error or str(exc)
    receipt.update(error=error, producer_receipt_sha256=io.digest(target/'producer/receipt.json'))
    io.write_json(target/'receipt.json',receipt)
    try:
        io.require(error is None, error or 'producer failed')
        if args.mode == 'solve':
            log=(target/'producer/run.log').read_text()
            io.require('\\S1206.CIF' in log and '\\S1207.CIF' in log and '\\S1208.CIF' in log,
                       'original Memory outcome/continuation files missing')
            io.require(any(o['state'][:2] == [1207,1207] and o['flags'].get(1988) == 1 for o in producer.observations), 'new1345 observed but transient1207/1988 win capture missing; no acceptance')
            saved=producer.saves/(args.save_name+'.SAV')
            output_state(saved,source)
            receipt['output_sha256']=io.digest(saved)
            reload=io.Session(args,target/'reload',saved,rc_flags=SCOPE)
            reload_error=None
            try:
                observation,image=send(reload,story_route.load_save_prefix()+';S3510.CIF+12000:move:635,385;S3510.CIF+15000:shot:0,0;S3510.CIF+18000:shot:0,0')
                io.require(observation['state']==[3510,3510,4,-1] and earned(observation)
                           and observation['flags'].get(1988,0)==0,'fresh output-only reload result differs')
                output_state(saved,source)
            except (Exception,KeyboardInterrupt) as exc:
                reload_error=str(exc) or type(exc).__name__
            finally:
                try:reload.close(reload_error)
                except (Exception,KeyboardInterrupt) as exc:reload_error=reload_error or str(exc)
            io.require(reload_error is None,reload_error or 'reload failed')
            receipt.update(accepted=True,reload_receipt_sha256=io.digest(target/'reload/receipt.json'))
        io.require(all(io.digest(Path(q))==h for q,h in protected.items()),'protected source changed')
        receipt['protected_inputs_unchanged']=True
        io.write_json(target/'receipt.json',receipt)
    except (Exception,KeyboardInterrupt) as exc:
        receipt.update(accepted=False,error=str(exc) or type(exc).__name__)
        io.write_json(target/'receipt.json',receipt)
        raise
    print(json.dumps(receipt,indent=2),flush=True)


if __name__ == '__main__':
    main()
