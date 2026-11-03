#!/usr/bin/env python3
"""One staged Betty deal from an explicit accepted NewGame campaign profile.

Original difficulty0/2, fixed160-request policy, no automatic retry. The
original owns cards, AI and time; only ordinary inputs and closed quest/item
gates guide this tool. Acceptance also requires a fresh output-only reload.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import struct
import sys

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import bul_live as io
import check_route
from capture_receipts import verify_captures

PROFILE_MODES = {'junior': 0, 'senior': 2}
LIVE_QUEST_FLAGS = frozenset((1160, 1541, 1782, 1906, 1963, 2002))
RC_FLAGS = ','.join(map(str, sorted(LIVE_QUEST_FLAGS | set(range(338, 342)))))
HELPERS = ('bul_live.py', 'story_route.py', 'check_route.py', 'capture_receipts.py')
INPUT_NAMES = ('load-keypad-start', 'settle-win', 'prize-open-take', 'select-real19',
               'put19', 'close-inventory', 'safe-exit', 'save-m13', 'reload-load',
               'reload-select19', 'reload-put19', 'reload-close') + tuple(
                   'requests-%02d' % i for i in range(32))
STAGED_INPUT_FILES_SHA256 = '0346dbd11b1d16b91bfaa871defba5cea049cf5d7d15ee237f78b896cc8763d5'
SAVE_DIR = Path('Documents5') / 'The Curse of Blackmoor Manor'


def clock_value(clock):
    io.require(clock['day'] >= 0 and 0 <= clock['hour'] < 24 and 0 <= clock['minute'] < 60
               and clock['total_minutes'] == 60 * clock['hour'] + clock['minute'],
               'invalid original clock')
    return clock['day'] * 1440 + clock['total_minutes']


def snapshot(path, flags):
    """Read only original header/events/owned items/ordered bag/clock."""
    state = io.save_state(path, progression_flags={int(x) for x in flags})
    data = path.read_bytes()
    state['progression'] = {str(k): v for k, v in state['progression'].items()}
    state['clock'] = {name: struct.unpack_from(fmt, data, offset)[0] for name, fmt, offset in
                      [('total_minutes', '<I', 0x2430), ('minute', '<H', 0x2434),
                       ('hour', '<H', 0x2436), ('day', '<H', 0x2438)]}
    clock_value(state['clock'])
    count = struct.unpack_from('<h', data, 0x110)[0]
    io.require(0 <= count <= 16, 'ordered bag exceeds one visible inventory page')
    state['ordered_bag'] = list(struct.unpack_from('<' + 'h' * count, data, 0x116))
    state['item_presence'] = {str(i): struct.unpack_from('<I', data, 0x2ba + 4*i)[0]
                              for i in range(40)}
    io.require(all(v in (0, 1) for v in state['item_presence'].values()), 'invalid item presence')
    io.require(len(set(state['ordered_bag'])) == count and
               set(state['ordered_bag']) == {int(i) for i, v in state['item_presence'].items() if v},
               'ordered bag/presence differs for this unheld profile')
    return state


def validate_input(payload):
    io.require(payload and payload.isascii() and len(payload.encode()) <= 65536 and
               '\n' not in payload and '\r' not in payload, 'invalid batch text')
    parts = payload.split(';')
    io.require(0 < len(parts) <= 512, 'finite ordinary-input batch budget exceeded')
    for step in parts:
        m = re.fullmatch(r'(?:[A-Za-z0-9_.]+\+)?\d+:(move|click|key|shot):([0-9,]+)', step)
        io.require(m is not None, 'nonordinary INPUT token')
        kind, text = m.groups(); values = [int(v) for v in text.split(',')]
        if kind == 'shot': io.require(values == [0, 0], 'invalid capture')
        elif kind == 'key': io.require(len(values) == 1 and 0 <= values[0] <= 255, 'invalid key')
        else:
            io.require(len(values) in ((2, 3) if kind == 'click' else (2,)) and
                       0 <= values[0] < 640 and 0 <= values[1] < 480, 'invalid pointer')
            if len(values) == 3: io.require(1 <= values[2] <= 6000, 'invalid click hold')
    io.require(any(':shot:' in s for s in parts), 'every batch must end at a closed capture')
    return len(parts)


def opened_scenes(log):
    return [int(x) for x in re.findall(r'FILE open .*?\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log, re.I)]


def one_deal(log):
    opened = opened_scenes(log)
    io.require(opened.count(2704) <= 1 and opened.count(2703) <= 1 and opened.count(2709) <= 1,
               'original loss/redeal or duplicate entry; one-deal scope exhausted')
    io.require(not set(opened).intersection({2706, 2721, 6301}), 'wrong/no-prize/GameOver branch')
    return opened


def outcome(observation):
    scene, art, view, held = observation['state']; won = observation['flags'].get(1963, 0)
    io.require(scene == art and view == 0 and held == -1, 'unrecognized deal state')
    if won == 1 and scene == 2711: return 'win'
    if won == 1 and scene in (2709, 2710): return 'settling'
    if won == 0 and scene == 2704: return 'pending'
    raise ValueError('original loss or unknown result; no reward, exit, Save or automatic retry')


def live(observation, spec, previous_clock, *, won=None, state=None):
    scope = check_route.flag_scope(observation['scope'], include_clock=True)
    io.require(scope == LIVE_QUEST_FLAGS | set(range(338, 342)), 'live observation scope differs')
    values = observation['flags']
    for flag in LIVE_QUEST_FLAGS - {1963}:
        io.require(values.get(flag, 0) == spec['source']['progression'][str(flag)],
                   'durable live quest event changed: ' + str(flag))
    if won is not None: io.require(values.get(1963, 0) == won, 'win flag differs at action gate')
    if state is not None: io.require(observation['state'] == state, 'scene/view/held action gate differs')
    clock = {'total_minutes': (values.get(338, 0) >> 16) | ((values.get(339, 0) & 65535) << 16),
             'minute': values.get(339, 0) >> 16, 'hour': values.get(340, 0) & 65535,
             'day': values.get(340, 0) >> 16}
    current = clock_value(clock)
    io.require(current >= previous_clock, 'original clock moved backwards')
    return current


def check_saved(state, source, *, output):
    wanted = dict(source['progression'])
    for flag in (1781, 1963, 1998):
        wanted[str(flag)] = int(output)
    io.require(type(state['difficulty']) is int and state['difficulty'] == source['difficulty'] in (0, 2) and
               [state[k] for k in ('scene', 'art', 'view', 'held')] ==
               ([2700, 2700, 0, -1] if output else [2701, 2701, 0, -1]), 'saved profile differs')
    io.require(state['progression'] == wanted, 'saved durable event set differs')
    presence = dict(source['item_presence']); presence['19'] = int(output)
    io.require(state['item_presence'] == presence, 'saved original inventory grant differs')
    io.require(state['ordered_bag'] == source['ordered_bag'] + ([19] if output else []),
               'saved ordered bag differs; normal known slot is no longer valid')
    io.require(clock_value(state['clock']) >= clock_value(source['clock']), 'saved clock predates source')
    if not output: io.require(state == source, 'exact campaign source metadata differs')


def verify_clone_inventory(game, seed_pins, allowed_saves):
    """Permit the original startup's exact config copy beside UI saves."""
    allowed = set(allowed_saves)
    config = SAVE_DIR / 'GAME.INI'
    if (game / config).is_file():
        io.require('Game.ini' in seed_pins and
                   io.digest(game / config) == seed_pins['Game.ini'],
                   'copied configuration differs from the original seed')
        allowed.add(str(config))
    io.require(not any(p.is_symlink() for p in game.rglob('*')) and
               {str(p.relative_to(game)) for p in game.rglob('*') if p.is_file()}
               == set(seed_pins) | allowed, 'clone resource/save inventory differs')
    for relative, expected in seed_pins.items():
        io.require(io.digest(game / relative) == expected, 'clone resource changed: ' + relative)


def verify_session(session, spec, *, producer):
    log = (session.out / 'run.log').read_text()
    io.require(session.receipt['returncode'] == 0 and not session.receipt.get('error'), 'session failed')
    io.require(session.receipt['source_unchanged'] and session.receipt['copy_unchanged'], 'source/copy changed')
    results = [s for s in log.splitlines() if s.startswith('RESULT ')]
    io.require(len(results) == 1 and re.match(r'RESULT \{\s*"stopped"\s*:\s*"stop requested(?: |")', results[0]),
               'normal requested stop missing')
    io.require(re.search(r'FILE open .*\\' + re.escape(session.source.name) + r'\s+\[virtual \d+ ms\]', log),
               'only supplied genuine save was not opened')
    capture_check = verify_captures(session.out, session.receipt['captures'], session.total[1])
    io.require(session.saves.joinpath(session.source.name).is_file(), 'source copy missing')
    save_catalog = {p.name: io.digest(p) for p in session.saves.glob('*.SAV')}
    io.require(set(save_catalog) <= {session.source.name, 'm13.SAV', 'HICONTINUECHEAT.SAV'}
               and save_catalog.get(session.source.name) == session.source_hash, 'unexpected/changed original UI save')
    allowed_saves = {str((SAVE_DIR / name)) for name in save_catalog}
    verify_clone_inventory(session.game, session.args.seed_pins, allowed_saves)
    if producer:
        opened = one_deal(log)
        io.require(all(n in opened for n in (2720, 2703, 2707, 2704, 2709, 2710, 2711, 2700)),
                   'required original authored win/prize path absent')
        io.require(re.search(r'FILE open .*\\m13\.SAV\s+\[virtual \d+ ms\]', log),
                   'original UI did not open new m13')
    else:
        io.require(not {2704, 2709, 2710}.intersection(opened_scenes(log)), 'reload started another game')
    return {'control_summary': session.receipt['control_summary'], 'result': results[0],
            'total_delivered_steps': session.total[0], 'total_closed_captures': session.total[1],
            'capture_catalog': capture_check,
            'initial_savs': session.receipt['initial_savs'],
            'savs_after': {p.name: io.digest(p) for p in session.saves.glob('*.SAV')},
            'requests_sha256': session.receipt['requests_sha256'], 'log_sha256': io.digest(session.out / 'run.log')}


def run_producer(args, root, source, spec):
    session = io.Session(args, root / 'producer', source, rc_flags=spec['RC_FLAGS'])
    error = None; clock = clock_value(spec['source']['clock']); history = []; requests = 0
    try:
        io.require({p.name for p in session.saves.glob('*.SAV')} == {source.name}, 'producer has extra source saves')
        session.receipt['initial_savs'] = {source.name: io.digest(session.copy)}
        for relative, expected in args.seed_pins.items():
            io.require(io.digest(session.game / relative) == expected, 'producer clone differs: ' + relative)
        def send(name, *, won=None, state=None):
            nonlocal clock, requests
            payload = (args.input_root / (name + '.txt')).read_text().strip()
            validate_input(payload)
            observation, image = session.send(payload)
            if name.startswith('requests-'): requests += 5
            # Validate every capture in the batch, including Load/keypad captures.
            for item in session.observations[len(history):]:
                clock = live(item, spec, clock)
                history.append(item)
            live(observation, spec, clock, won=won, state=state)
            one_deal((session.out / 'run.log').read_text())
            io.write_json(session.out / f'gate-{session.request_id:03d}.json',
                          {'stage': name, 'observation': observation, 'capture': image.name,
                           'capture_sha256': io.digest(image), 'rank_requests_delivered': requests})
            return observation
        observation = send('load-keypad-start', won=0, state=[2704, 2704, 0, -1])
        for group in range(32):
            io.require(outcome(observation) == 'pending', 'rank request issued outside pending deal')
            observation = send(f'requests-{group:02d}')
            kind = outcome(observation)
            if kind in ('win', 'settling'): break
        for _ in range(3):
            if outcome(observation) != 'settling': break
            observation = send('settle-win')
        io.require(outcome(observation) == 'win', '160-request bound unfinished; no checkpoint actions')
        # No reward interaction until original1963 and actual settled2711.
        send('prize-open-take', won=1, state=[2711, 2711, 0, -1])
        send('select-real19', won=1, state=[2711, 2711, 0, 19])
        # No PUT/X/world exit until actual held19 has been observed.
        send('put19', won=1, state=[2711, 2711, 0, -1])
        send('close-inventory', won=1, state=[2711, 2711, 0, -1])
        send('safe-exit', won=1, state=[2700, 2700, 0, -1])
        # Only the safe original world result permits opening Save UI.
        io.require(not (session.saves / 'm13.SAV').exists(), 'output existed before original UI Save')
        send('save-m13', won=1, state=[2700, 2700, 0, -1])
        saved = session.saves / 'm13.SAV'
        io.require(saved.is_file(), 'original UI m13 output missing')
        saved_state = snapshot(saved, spec['source']['progression'])
        check_saved(saved_state, spec['source'], output=True)
    except (Exception, KeyboardInterrupt) as exc:
        error = str(exc) or type(exc).__name__
    finally:
        session.receipt.update(rank_requests_delivered=requests, one_deal_only=True,
                               no_automatic_retry=True, action_gates=history)
        session.close(error)
    verification = verify_session(session, spec, producer=True)
    verification['public_checker'] = check_route.verify((session.out / 'run.log').read_text(), saved, 'betty-key')
    verification.update(source_sha256=io.digest(source), output_sha256=io.digest(saved),
                        saved_state=saved_state, rank_requests_delivered=requests)
    return saved, verification


def run_reload(args, root, saved, state, spec):
    session = io.Session(args, root / 'reload', saved, rc_flags=spec['RC_FLAGS'])
    error = None; clock = clock_value(state['clock']); seen = 0
    try:
        io.require({p.name for p in session.saves.glob('*.SAV')} == {'m13.SAV'}, 'reload has extra saves')
        session.receipt['initial_savs'] = {'m13.SAV': io.digest(session.copy)}
        for relative, expected in args.seed_pins.items():
            io.require(io.digest(session.game / relative) == expected, 'reload clone differs: ' + relative)
        for name, expected in [('reload-load', -1), ('reload-select19', 19),
                               ('reload-put19', -1), ('reload-close', -1)]:
            payload = (args.input_root / (name + '.txt')).read_text().strip()
            validate_input(payload); observation, _ = session.send(payload)
            for item in session.observations[seen:]: clock = live(item, spec, clock, won=1)
            seen = len(session.observations)
            live(observation, spec, clock, won=1, state=[2700, 2700, 0, expected])
        io.require(io.digest(session.copy) == io.digest(saved), 'fresh-only reload modified saved bytes')
        check_saved(snapshot(session.copy, spec['source']['progression']), spec['source'], output=True)
    except (Exception, KeyboardInterrupt) as exc:
        error = str(exc) or type(exc).__name__
    finally: session.close(error)
    return verify_session(session, spec, producer=False)


def validate_profile(profile):
    """Concrete cohort metadata, never a difficulty/rules override."""
    keys = {'version', 'name', 'difficulty', 'native_sha256', 'source_sha256', 'source',
            'origin_chain', 'helpers', 'input_files', 'seed_pins', 'external_programs'}
    io.require(isinstance(profile, dict) and set(profile) == keys and type(profile['version']) is int
               and profile['version'] == 1, 'unsupported typed campaign profile')
    io.require(profile['name'] in PROFILE_MODES and type(profile['difficulty']) is int
               and profile['difficulty'] == PROFILE_MODES[profile['name']], 'original profile difficulty must be0 or2')
    is_hash = lambda value: isinstance(value, str) and re.fullmatch('[0-9a-f]{64}', value) is not None
    io.require(all(is_hash(profile[k]) for k in ('native_sha256', 'source_sha256')), 'profile hash differs')
    source = profile['source']
    io.require(isinstance(source, dict) and set(source) == {'difficulty', 'scene', 'art', 'view', 'held',
               'progression', 'clock', 'item_presence', 'ordered_bag'} and
               type(source['difficulty']) is int and source['difficulty'] == profile['difficulty'], 'source mode/fields differ')
    flags = source['progression']
    io.require(isinstance(flags, dict) and all(isinstance(k, str) and k.isdecimal() for k in flags)
               and LIVE_QUEST_FLAGS | {1781, 1998} <= {int(k) for k in flags}
               and all(re.fullmatch(r'0|[1-9][0-9]*', k) and 0 <= int(k) <= 2250
                       and int(k) not in range(338, 342) and type(v) is int and v in (0, 1)
                       for k, v in flags.items()), 'invalid full saved event set')
    io.require(all(flags[str(f)] == 1 for f in LIVE_QUEST_FLAGS - {1963})
               and all(flags[str(f)] == 0 for f in (1781, 1963, 1998)), 'source prerequisites/win phase differ')
    io.require(set(source['item_presence']) == {str(i) for i in range(40)}
               and all(type(v) is int and v in (0, 1) for v in source['item_presence'].values())
               and source['item_presence']['19'] == 0, 'complete source item set required')
    bag = source['ordered_bag']
    io.require(isinstance(bag, list) and len(bag) == len(set(bag)) == 4
               and all(type(i) is int and 0 <= i < 40 for i in bag)
               and set(bag) == {int(i) for i, v in source['item_presence'].items() if v}, 'four-item source bag differs')
    io.require(isinstance(source['clock'], dict) and set(source['clock']) == {'day', 'hour', 'minute', 'total_minutes'}
               and all(type(v) is int for v in source['clock'].values()), 'source clock metadata differs')
    check_saved(source, source, output=False)
    io.require(set(profile['helpers']) == set(HELPERS) and set(profile['input_files']) == set(INPUT_NAMES),
               'helper/input profile set differs')
    for mapping in (profile['helpers'], profile['input_files'], profile['seed_pins']):
        io.require(isinstance(mapping, dict) and mapping and all(isinstance(k, str) and k and
                   not Path(k).is_absolute() and '..' not in Path(k).parts and is_hash(v)
                   for k, v in mapping.items()), 'invalid pinned file map')
    io.require(isinstance(profile['origin_chain'], list) and 0 < len(profile['origin_chain']) <= 32
               and all(isinstance(r, dict) and set(r) == {'file', 'sha256'} and isinstance(r['file'], str)
                       and r['file'] and not Path(r['file']).is_absolute() and '..' not in Path(r['file']).parts
                       and is_hash(r['sha256']) for r in profile['origin_chain']), 'accepted NewGame lineage required')
    io.require(isinstance(profile['external_programs'], list) and all(isinstance(r, dict)
               and isinstance(r.get('program'), str) and '/' not in r['program'] and r['program']
               and is_hash(r.get('sha256')) for r in profile['external_programs']), 'invalid decoder pins')
    return profile


def validate_lineage(records, profile):
    """Every stage edge must lead from the accepted zero-save NewGame."""
    io.require(isinstance(records, list) and records, 'accepted NewGame lineage missing')
    previous = None
    for index, record in enumerate(records):
        io.require(record.get('accepted') is True and record.get('protected_inputs_unchanged') is True
                   and record.get('native_sha256') == profile['native_sha256'], 'unaccepted campaign lineage')
        if index == 0:
            io.require(record.get('no_incoming_save') is True and 'origin_source' in record
                       and record['origin_source'] is None, 'lineage lacks zero-save NewGame')
        else:
            io.require(record.get('source_sha256') == previous
                       and record.get('original_NewGame_origin_preserved') is True, 'campaign predecessor differs')
        stages = record.get('stages')
        io.require(isinstance(stages, list) and stages, 'lineage has no accepted stages')
        for stage in stages:
            io.require(stage.get('source_sha256') == previous and isinstance(stage.get('state'), dict)
                       and type(stage['state'].get('difficulty')) is int
                       and stage['state']['difficulty'] == profile['difficulty'], 'stage lineage/mode differs')
            previous = stage.get('output_sha256')
            io.require(isinstance(previous, str) and re.fullmatch('[0-9a-f]{64}', previous), 'invalid stage output pin')
    io.require(previous == profile['source_sha256'], 'source does not end the accepted NewGame lineage')
    last = records[-1]['stages'][-1]['state']
    io.require(all(str(k) in profile['source']['progression'] and profile['source']['progression'][str(k)] == v
                   for k, v in last['progression'].items()), 'profile lost carried saved fields')
    for key in ('difficulty', 'scene', 'art', 'view', 'held', 'clock', 'item_presence', 'ordered_bag'):
        io.require(last[key] == profile['source'][key], 'source/lineage metadata differs: ' + key)
    return True


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('native', 'game-exe', 'game-data', 'source-save', 'output', 'campaign-profile', 'lineage-root'):
        parser.add_argument('--' + name, type=Path, required=True)
    for name in ('native-sha256', 'save-sha256', 'profile-sha256'):
        parser.add_argument('--' + name, required=True)
    parser.add_argument('--profile', choices=tuple(PROFILE_MODES), required=True)
    parser.add_argument('--run-approved', action='store_true')
    parser.add_argument('--timeout', type=int, default=300)
    args = parser.parse_args(argv)
    io.require(args.run_approved and 1 <= args.timeout <= 300, 'explicit run opt-in/bounded timeout required')
    io.require(not args.campaign_profile.is_symlink() and args.campaign_profile.stat().st_size <= 2 * 1024 * 1024
               and io.digest(args.campaign_profile) == args.profile_sha256, 'typed profile pin differs')
    profile = validate_profile(json.loads(args.campaign_profile.read_text()))
    io.require(args.profile == profile['name'] and args.native_sha256 == profile['native_sha256']
               and args.save_sha256 == profile['source_sha256'], 'CLI/profile native/source/mode differs')
    for name in ('native', 'game_exe', 'game_data', 'source_save', 'campaign_profile', 'lineage_root'):
        setattr(args, name, getattr(args, name).resolve(strict=True))
    args.input_root = args.campaign_profile.parent / 'inputs'
    input_map_hash = hashlib.sha256(json.dumps(profile['input_files'], sort_keys=True, separators=(',', ':')).encode()).hexdigest()
    io.require(input_map_hash == STAGED_INPUT_FILES_SHA256, 'reviewed staged input policy changed')
    protected = {str(args.campaign_profile): args.profile_sha256, str(Path(__file__).resolve()): io.digest(Path(__file__))}
    for name, expected in profile['helpers'].items():
        io.require(io.digest(HERE / name) == expected, 'shared helper pin differs: ' + name)
        protected[str(HERE / name)] = expected
    for name, expected in profile['input_files'].items():
        path = args.input_root / (name + '.txt')
        io.require(not path.is_symlink() and io.digest(path) == expected, 'staged input pin differs: ' + name)
        validate_input(path.read_text().strip())
        protected[str(path)] = expected
    records = []
    for origin in profile['origin_chain']:
        path = args.lineage_root / origin['file']
        io.require(not path.is_symlink() and path.stat().st_size <= 8 * 1024 * 1024
                   and io.digest(path) == origin['sha256'], 'accepted lineage receipt pin differs')
        records.append(json.loads(path.read_text()))
        protected[str(path)] = origin['sha256']
    validate_lineage(records, profile)
    io.require(Path(records[-1]['stages'][-1]['checkpoint']).resolve() == args.source_save,
               'source is not its accepted canonical checkpoint')
    io.require(args.source_save.name == 'm12.SAV' and io.digest(args.source_save) == args.save_sha256
               and io.digest(args.native) == args.native_sha256, 'native/genuine source pin differs')
    source = snapshot(args.source_save, profile['source']['progression'])
    check_saved(source, profile['source'], output=False)
    io.require(io.digest(args.game_exe) == io.digest(args.game_data / 'GAME.EXE') == io.ORIGINAL_SHA256,
               'original image differs')
    io.require(not (args.game_data / 'Documents5').exists()
               and not any(p.is_symlink() for p in args.game_data.rglob('*')), 'seed contains saves/symlinks')
    args.seed_pins = profile['seed_pins']
    io.require(len(args.seed_pins) == 3560 and
               {str(p.relative_to(args.game_data)) for p in args.game_data.rglob('*') if p.is_file()}
               == set(args.seed_pins) and not any(p.lower().endswith('.sav') for p in args.seed_pins), 'seed inventory differs')
    for relative, expected in args.seed_pins.items():
        io.require(io.digest(args.game_data / relative) == expected, 'original seed pin differs: ' + relative)
        protected[str(args.game_data / relative)] = expected
    for item in profile['external_programs']:
        found = shutil.which(item['program'])
        io.require(found is not None and io.digest(Path(found).resolve()) == item['sha256'], 'decoder pin differs')
    protected.update({str(args.native): args.native_sha256, str(args.game_exe): io.ORIGINAL_SHA256,
                      str(args.source_save): args.save_sha256})
    root = args.output.resolve()
    io.require(not root.exists() and root != HERE and HERE not in root.parents
               and args.game_data not in root.parents and root not in args.game_data.parents
               and root != args.game_exe.parent and args.game_exe.parent not in root.parents,
               'new output outside original/helper directory required')
    root.mkdir(parents=True, exist_ok=False)
    (root / 'checkpoints').mkdir()
    os.environ.pop('SCRIPT_TAIL_MS', None)
    spec = {'source': source, 'RC_FLAGS': RC_FLAGS}
    receipt = {'accepted': False, 'profile': args.profile, 'difficulty': profile['difficulty'],
               'native_sha256': args.native_sha256, 'source_sha256': args.save_sha256,
               'source_save': str(args.source_save), 'source_state': source, 'profile_sha256': args.profile_sha256,
               'saved_field_count': len(source['progression']), 'live_scope': RC_FLAGS,
               'protected_inputs': protected, 'no_automatic_retry': True, 'original_NewGame_origin_preserved': True}
    io.write_json(root / 'receipt.json', receipt)
    try:
        saved, produced = run_producer(args, root, args.source_save, spec)
        io.require(all(io.digest(Path(path)) == expected for path, expected in protected.items()), 'protected input changed')
        reloaded = run_reload(args, root, saved, produced['saved_state'], spec)
        io.require(io.digest(saved) == produced['output_sha256'], 'new UI output changed during reload')
        target = root / 'checkpoints' / 'm13.SAV'
        shutil.copy2(saved, target)
        io.require(io.digest(target) == produced['output_sha256'], 'accepted checkpoint copy differs')
        receipt.update(accepted=True, producer=produced, fresh_output_only_reload=reloaded,
                       checkpoint=str(target), output_sha256=io.digest(target))
    except (Exception, KeyboardInterrupt) as exc:
        receipt['error'] = str(exc) or type(exc).__name__
        raise
    finally:
        receipt['protected_inputs_unchanged'] = all(io.digest(Path(path)) == expected for path, expected in protected.items())
        if not receipt['protected_inputs_unchanged']:
            receipt['accepted'] = False
        io.write_json(root / 'receipt.json', receipt)
    io.require(receipt['protected_inputs_unchanged'], 'protected inputs changed')
    print('ACCEPTED_BETTY', args.profile, receipt['output_sha256'], flush=True)


if __name__ == '__main__':
    main()
