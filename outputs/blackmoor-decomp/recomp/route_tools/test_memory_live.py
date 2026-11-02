"""Finite Memory pixel/INPUT/profile fixtures. No native/game/build execution."""
import argparse
import hashlib
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
parser = argparse.ArgumentParser()
parser.add_argument('--report', type=Path)
parser.add_argument('--verified-case', type=Path, nargs=3, action='append', default=[],
                    metavar=('PROFILE','SOURCE','OUTPUT'))
args = parser.parse_args()
import bul_live as io
import memory_pixels as px
import memory_live as live
import memory_profile as profiles


def expect_refused(fn):
    try:
        fn()
    except ValueError:
        return
    raise AssertionError('expected ordinary validation refusal')


def frame(exposed=None):
    # Artificial opaque colors only; no game/template/resource pixels.
    data = bytearray(640*480*3)
    for index, identity in (exposed or {}).items():
        left = px.RAW_LEFT[index%6] + 10 + px.INSET
        top = px.RAW_TOP[index//6] + 10 + px.INSET
        color = bytes((identity+1, 50+identity, 150+identity))
        for y in range(px.HEIGHT):
            at = ((top+y)*640+left)*3
            data[at:at+px.WIDTH*3] = color*px.WIDTH
    return bytes(data)

checks = []
#1 actual metadata geometry and the ordinary capture window.
for i in range(24):
    x,y = px.point(i)
    assert px.RAW_LEFT[i%6]+3 <= x-1 <= px.RAW_LEFT[i%6]+89-3
    assert px.RAW_TOP[i//6]+3 <= y-1 <= px.RAW_TOP[i//6]+79-3
    payload = px.flip_payload(i)
    assert live.validate_payload(payload) == payload
    assert ':move:635,385' in payload
    shots = [int(s.split(':',1)[0]) for s in payload.split(';') if ':shot:' in s]
    assert shots == [251,451] and all(181 < t < 101+600 for t in shots)
checks.append('24 geometry points; parked closed captures before600ms; normal settle beyond600ms')

#2 hidden/stale captures cannot supply identities.
base = frame()
mem = px.FaceMemory(base)
expect_refused(lambda:mem.reveal(base,0))
mem.reveal(frame({0:0}),0)
expect_refused(lambda:mem.reveal(frame({0:1}),0))
mem.reveal(frame({1:0}),1)
expect_refused(lambda:mem.reveal(frame({2:0}),2))
checks.append('hidden, unstable and third-identical-face captures refused')

mismatch = px.FaceMemory(base)
still_exposed = frame({0:0,1:1})
assert not mismatch.pair(0,1,still_exposed)
expect_refused(lambda:mismatch.settled(still_exposed,0,1,False))
mismatch.settled(base,0,1,False)

#3 worst-case discovery12mismatches + recall12matches uses24 attempts.
mem = px.FaceMemory(base)
deck = list(range(12))*2
for first in range(0,24,2):
    mem.reveal(frame({first:deck[first]}),first)
    seen = frame({first:deck[first],first+1:deck[first+1]})
    assert not mem.pair(first,first+1,seen)
    mem.settled(base,first,first+1,False)
assert mem.attempts == 12
pairs = mem.recalled_pairs()
assert len(pairs) == 12
for a,b in pairs:
    seen = frame({a:deck[a],b:deck[b]})
    assert mem.pair(a,b,seen)
    mem.settled(seen,a,b,True)
assert mem.attempts == 24 and len(mem.matched) == 24
expect_refused(lambda:mem.pair(*pairs[0],frame({pairs[0][0]:0,pairs[0][1]:0})))
checks.append('synthetic complete discovery/recall schedule bounded24; matched cards not reused')

#4 the original guest result, not pixels/ACK/scene entry, grants a win.
assert not live.earned({'flags':{1988:1,1345:0}})
assert not live.earned({'flags':{1345:0}})
assert live.earned({'flags':{1345:1}})
expect_refused(lambda:live.validate_payload('1:flag:1345,1'))
expect_refused(lambda:live.validate_payload('1:move:-1,10'))
expect_refused(lambda:live.validate_payload('1:click:10,10,0'))
expect_refused(lambda:live.save_payload('continue'))
live.validate_payload(live.save_payload('mem1'))
checks.append('new durable result required; nonordinary events/invalid UI names refused')

#5 existing closed P6 parser is reused with synthetic bytes, not reimplemented.
class Capture:
    def __init__(self,value):self.value=value
    def read_bytes(self):return self.value
assert io.ppm(Capture(b'P6\n640 480\n255\n'+base)) == base
expect_refused(lambda:io.ppm(Capture(b'P6\n640 480\n255\n'+base[:-1])))
checks.append('existing PPM parser accepts complete synthetic capture/refuses partial')

#6 profile guards; optional actual saved fields are read only, never mutated.
config={'name':'junior','difficulty':0,'source_sha256':'0'*64,
        'clock':{'day':3,'hour':14,'minute':57,'total_minutes':897}}
assert profiles.validate(config)==config
expect_refused(lambda:profiles.validate(dict(config,difficulty=2)))
expect_refused(lambda:profiles.validate(dict(config,source_sha256='not-a-digest')))
expect_refused(lambda:profiles.validate(dict(config,clock={'day':3,'hour':14,'minute':57,'total_minutes':898})))
verified=[]
for profile_path,source_path,output_path in args.verified_case:
    profile=profiles.load(profile_path)
    source_hash=io.digest(source_path)
    output_hash=io.digest(output_path)
    state=live.source_state(source_path,profile)
    result=live.output_state(output_path,state)
    assert state['progression'][1345]==state['progression'][1335]==state['progression'][1988]==0
    assert result['progression'][1345]==result['progression'][1335]==1
    assert result['progression'][1988]==result['progression'][2072]==0
    assert source_hash==io.digest(source_path)==profile['source_sha256']
    assert output_hash==io.digest(output_path)
    verified.append({'profile':profile['name'],'source_sha256':source_hash,
                     'output_sha256':output_hash,'source_state':state,'output_state':result})
if len(args.verified_case)==2:
    first,second=args.verified_case
    expect_refused(lambda:live.source_state(first[1],profiles.load(second[0])))
    expect_refused(lambda:live.source_state(second[1],profiles.load(first[0])))
checks.append('explicit profile/difficulty/hash/clock guards; optional genuine saved-field checks remain read-only')

result={'result':'PASS','scope':'six finite fixtures; no native/game/build/oracle/fault execution',
        'checks':checks,'verified_cases':verified,
        'candidate_pins':{name:hashlib.sha256((Path(__file__).parent/name).read_bytes()).hexdigest()
                          for name in ['memory_live.py','memory_pixels.py','memory_profile.py','test_memory_live.py']}}
if args.report:
    args.report.write_text(json.dumps(result,indent=2)+'\n')
print('PASS',len(checks),'finite Memory fixtures;',len(verified),'read-only genuine source/output cases; no native execution')
