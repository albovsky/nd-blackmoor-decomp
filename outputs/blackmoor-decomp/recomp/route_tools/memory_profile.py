"""Read-only source/output guards for the ordinary-input Memory controller.

A profile pins an expected genuine save and clock; it never sets difficulty,
clock, inventory or puzzle state. Only Junior0 and Senior2 are supported.
"""
import json
import re
import struct

import bul_live as io

ONE = {1357,1361,1404,1405,1567,1791,1865,1980,2001}
ZERO = {1335,1345,1988,2017,2072}
DIFFICULTIES = {'junior': (0,40), 'senior': (2,25)}


def validate(profile):
    io.require(isinstance(profile,dict) and set(profile)=={'name','difficulty','source_sha256','clock'},
               'profile must pin name, difficulty, source_sha256 and clock')
    io.require(profile['name'] in DIFFICULTIES, 'unsupported Memory profile')
    difficulty, limit = DIFFICULTIES[profile['name']]
    io.require(type(profile['difficulty']) is int and profile['difficulty']==difficulty,
               'profile name/difficulty differs')
    io.require(isinstance(profile['source_sha256'],str)
               and re.fullmatch(r'[0-9a-f]{64}',profile['source_sha256']) is not None,
               'profile needs an explicit source SHA-256')
    clock=profile['clock']
    io.require(isinstance(clock,dict) and set(clock)=={'total_minutes','minute','hour','day'}
               and all(type(v) is int for v in clock.values()), 'profile clock fields differ')
    io.require(clock['day']>=1 and 0<=clock['hour']<24 and 0<=clock['minute']<60
               and clock['total_minutes']==60*clock['hour']+clock['minute'], 'invalid expected original clock')
    io.require(24<=limit, 'bounded observed policy exceeds authored profile attempt limit')
    return profile


def load(path):
    return validate(json.loads(path.read_text()))


def clock_fields(data):
    return {name:struct.unpack_from(fmt,data,offset)[0] for name,fmt,offset in
            [('total_minutes','<I',0x2430),('minute','<H',0x2434),('hour','<H',0x2436),('day','<H',0x2438)]}


def source_state(path, profile):
    validate(profile)
    io.require(io.digest(path)==profile['source_sha256'], 'source is not the explicitly pinned genuine save')
    s=io.save_state(path,progression_flags=ONE|ZERO)
    io.require(s['difficulty']==profile['difficulty']
               and [s[k] for k in ('scene','art','view','held')]==[3510,3510,4,-1],
               'source scene/view/hand/difficulty differs')
    io.require(all(s['progression'][f]==1 for f in ONE) and all(s['progression'][f]==0 for f in ZERO),
               'source Memory/prerequisite flags differ')
    data=path.read_bytes()
    clock=clock_fields(data)
    io.require(clock==profile['clock'], 'source expected original clock differs')
    items={i:struct.unpack_from('<I',data,0x2ba+4*i)[0] for i in range(40)}
    io.require({i:items[i] for i in (2,4,5,13)}=={2:1,4:1,5:0,13:0}, 'source critical inventory differs')
    s.update(clock_overlap_diagnostics=clock,item_presence=items)
    return s


def output_state(path, source):
    s=io.save_state(path,progression_flags=ONE|{1335,1345,1988,2072})
    io.require(s['difficulty']==source['difficulty']
               and [s[k] for k in ('scene','art','view','held')]==[3510,3510,4,-1],
               'output must be the normal safe original room')
    io.require(all(s['progression'][f]==1 for f in ONE|{1335,1345})
               and s['progression'][1988]==s['progression'][2072]==0,
               'new Memory durable/transient results differ')
    data=path.read_bytes()
    io.require({i:struct.unpack_from('<I',data,0x2ba+4*i)[0] for i in range(40)}==source['item_presence'],
               'Memory has no item reward; original item presence unexpectedly changed')
    clock=clock_fields(data)
    before=source['clock_overlap_diagnostics']
    io.require(0<=clock['hour']<24 and 0<=clock['minute']<60
               and clock['total_minutes']==60*clock['hour']+clock['minute']
               and clock['day']*1440+clock['total_minutes']>=before['day']*1440+before['total_minutes'],
               'output original clock is inconsistent/backwards')
    s['clock_overlap_diagnostics']=clock
    return s
