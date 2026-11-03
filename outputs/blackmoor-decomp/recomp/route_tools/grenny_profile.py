"""Read-only Grenny source/output guards and ordinary inventory coordinates."""
import json
import re
import struct
import bul_live as io

PROFILE_DIFFICULTIES={'junior-grenny':0,'senior-grenny':2}

WIN={1978,2064,2226}
ONE={1959,1960,1972,2017,2052}
ZERO={1879,1973,1999,2004}
# Internal readiness latch 2127 is checked only in completed saves.
LIVE=ONE|ZERO|WIN|{1335,1338,1345,1502,1503,1840,1988,2008,2072,2084}


def clock(data):
    c={name:struct.unpack_from(fmt,data,offset)[0]for name,fmt,offset in
       [('total_minutes','<I',0x2430),('minute','<H',0x2434),('hour','<H',0x2436),('day','<H',0x2438)]}
    io.require(c['day']>=1 and 0<=c['hour']<24 and 0<=c['minute']<60 and
               c['total_minutes']==60*c['hour']+c['minute'],'invalid original clock')
    return c


def clock_total(c):return c['day']*1440+c['total_minutes']


def snapshot(path,fields):
    state=io.save_state(path,progression_flags={int(f)for f in fields});d=path.read_bytes()
    count=struct.unpack_from('<h',d,0x110)[0];io.require(0<=count<=16,'original bag count differs')
    bag=list(struct.unpack_from('<'+'h'*count,d,0x116));items=list(struct.unpack_from('<40I',d,0x2ba))
    io.require(all(v in(0,1)for v in items)and len(set(bag))==len(bag)and set(bag)=={i for i,v in enumerate(items)if v},
               'original full40/ordered bag differs')
    state.update(flags={str(k):v for k,v in state.pop('progression').items()},inventory40=items,
                 ordered_bag=bag,clock=clock(d))
    return state


def validate(profile,profile_name='junior-grenny'):
    difficulty=PROFILE_DIFFICULTIES.get(profile_name)
    io.require(difficulty is not None and profile.get('name')==profile_name
               and type(profile.get('difficulty'))is int and profile['difficulty']==difficulty,
               'profile must match the selected original difficulty name/mode')
    for key in('native_sha256','source_sha256'):
        io.require(isinstance(profile.get(key),str)and re.fullmatch('[0-9a-f]{64}',profile[key]),'unbound '+key)
    io.require(profile['native_sha256']!=io.ORIGINAL_SHA256,'native is not the original data image')
    io.require(profile.get('source_state')==[2460,2460,0,-1],'safe before-Grenny profile required')
    io.require(isinstance(profile.get('flags'),dict)and all(str(int(k))==k and type(v)is int and v in(0,1)for k,v in profile['flags'].items())
               and LIVE<={int(f)for f in profile['flags']},'complete source/optional/Grenny fields required')
    flags=profile['flags']
    io.require(all(flags[str(f)]==1 for f in ONE)and all(flags[str(f)]==0 for f in ZERO|WIN),'source prerequisite/win phase differs')
    items=profile.get('inventory40');bag=profile.get('ordered_bag')
    io.require(isinstance(items,list)and len(items)==40 and all(type(v)is int and v in(0,1)for v in items)
               and isinstance(bag,list)and all(type(v)is int for v in bag)and len(set(bag))==len(bag)
               and set(bag)=={i for i,v in enumerate(items)if v},'profile full40/ordered bag differs')
    io.require(items[8]==0 and len(bag)<16,'real8 must be unearned and a reward slot must be available')
    c=profile.get('clock')
    io.require(isinstance(c,dict)and set(c)=={'total_minutes','minute','hour','day'}and all(type(v)is int for v in c.values())
               and c['day']>=1 and 0<=c['hour']<24 and 0<=c['minute']<60
               and c['total_minutes']==60*c['hour']+c['minute'],'bound actual source clock required')
    return profile


def read(path,profile_name='junior-grenny'):return validate(json.loads(path.read_text()),profile_name)


def check_data(root,pins,*,runtime_saves=False):
    """Check every cloned asset; only the game's save directory may be new."""
    paths=list(root.rglob('*'))
    io.require(not any(p.is_symlink()for p in paths),'data inventory contains a symlink')
    files={str(p.relative_to(root)):p for p in paths if p.is_file()
           and not(runtime_saves and p.relative_to(root).parts[0]=='Documents5')}
    io.require(isinstance(pins,dict)and pins and set(pins)==set(files),
               'complete data file inventory differs')
    for name,path in files.items():
        io.require(isinstance(pins[name],str)and re.fullmatch('[0-9a-f]{64}',pins[name])
                   and io.digest(path)==pins[name],'data file hash differs: '+name)


def source_state(path,profile,profile_name='junior-grenny'):
    validate(profile,profile_name);io.require(io.digest(path)==profile['source_sha256'],'actual source SHA differs')
    state=snapshot(path,profile['flags'])
    io.require(state['difficulty']==profile['difficulty']and[state[k]for k in('scene','art','view','held')]==profile['source_state']
               and all(state[k]==profile[k]for k in('flags','inventory40','ordered_bag','clock')),'actual source profile differs')
    return state


def expected_output(source):
    flags=dict(source['flags']);flags.update({str(f):1 for f in WIN})
    items=list(source['inventory40']);io.require(items[8]==0,'item8 was already owned');items[8]=1
    return dict(flags=flags,inventory40=items,ordered_bag=source['ordered_bag']+[8])


def check_output(state,source):
    expected=expected_output(source)
    io.require(type(source['difficulty'])is int and source['difficulty']in PROFILE_DIFFICULTIES.values()
               and type(state['difficulty'])is int and state['difficulty']==source['difficulty']
               and[state[k]for k in('scene','art','view','held')]==[2460,2460,0,-1],
               'safe original fountain output differs')
    io.require(all(state[k]==expected[k]for k in expected),'actual earned8/expanded events/full40/bag differs')
    io.require(clock_total(state['clock'])>=clock_total(source['clock']),'saved clock predates genuine source')
    return state


def slot(index):
    io.require(type(index)is int and 0<=index<16,'inventory slot outside16')
    return(62+72*(index%4),100+70*(index//4))


def first_free_slot(bag):
    io.require(len(set(bag))==len(bag)and len(bag)<16,'no ordinary free inventory slot')
    return slot(len(bag))


def item_slot(state,item):
    io.require(item in state['ordered_bag'],'actual produced bag lacks required item')
    return slot(state['ordered_bag'].index(item))
