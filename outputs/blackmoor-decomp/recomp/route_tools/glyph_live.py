#!/usr/bin/env python3
"""One first-time Junior glyph attempt using actual pixels and ordinary FIFO input.

The caller owns the pinned local atlas. No atlas/asset payload is distributed.
The original game owns all swaps, scores, timers, wins, rewards and UI saves.
"""
import argparse
import json
from pathlib import Path
import re
import shutil
import struct
import tempfile

import bul_live as io
import check_route
import glyph_pixels
import story_route

MAX_GLYPH_REQUESTS = 64


def source_state(path):
    _, one, zero = check_route.dragon_light_configuration('glyph-request')
    state = io.save_state(path, progression_flags=one | zero)
    io.require(state['difficulty'] == 0 and [state[k] for k in ('scene', 'art', 'view', 'held')] == [3510, 3510, 4, -1]
               and all(state['progression'].get(f) == 1 for f in one)
               and all(state['progression'].get(f) == 0 for f in zero),
               'source must be a first-time pending Junior m28; repeat/Senior sources are refused')
    data = path.read_bytes()
    clock = {name: struct.unpack_from(fmt, data, offset)[0] for name, fmt, offset in (
        ('total_minutes', '<I', 0x2430), ('minute', '<H', 0x2434), ('hour', '<H', 0x2436), ('day', '<H', 0x2438))}
    io.require(clock['day'] == 2 and 16 <= clock['hour'] <= 19 and 0 <= clock['minute'] < 60
               and clock['total_minutes'] == clock['hour'] * 60 + clock['minute'], 'source clock gate differs')
    state['clock_diagnostics'] = clock
    return state


def rc_flags():
    _, one, zero = check_route.glyph_win_configuration()
    runs = []
    for value in sorted(one | zero | set(range(338, 342))):
        if runs and value == runs[-1][1] + 1:
            runs[-1][1] = value
        else:
            runs.append([value, value])
    return ','.join(str(a) if a == b else f'{a}-{b}' for a, b in runs)


def numeric(items):
    return ';'.join(f'{t}:{kind}:{args}' for t, kind, args in items)


def board_prefix():
    r = story_route.R().at('S3510.CIF', 12000)
    r.clicks('200,330 shot 317,159 shot 354,227 shot', 8000)
    r.at('S3510.CIF', 76000).clicks('shot', 0)
    r.at('S3510.CIF', 84000).clicks('480,152,300', 0)
    r.o += ['S3588.CIF+500:move:635,385', 'S3588.CIF+1000:shot:0,0']
    return r.text()


def event_payload(events):
    return numeric((event['after_ms'], event['kind'], f"{event['x']},{event['y']}" +
                    (f",{event['hold_ms']}" if event['kind'] == 'click' else '')) for event in events)


def continue_payload():
    return '1:move:635,385;12000:shot:0,0'


def pickup_payload():
    return '1:move:287,176;101:click:287,176,300;16000:shot:0,0'


def caption_payload():
    items = [(1, 'move', '22,405'), (101, 'click', '22,405,6000')]
    items += [(601 + 400*j, 'move', f'22,{y}') for j, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
    return numeric(items + [(8001, 'shot', '0,0')])


def bye_payload():
    return ('1:move:150,438;101:click:150,438,300;12001:shot:0,0;'
            '13001:move:212,448;13101:click:212,448,300;16001:shot:0,0')


def inventory_save_payload(name):
    io.require(re.fullmatch('[a-z0-9]{1,10}', name) is not None and name != 'continue', 'invalid UI save name')
    items = [(1, 'move', '60,100'), (101, 'click', '60,100,300'), (1001, 'shot', '0,0'),
             (2001, 'move', '212,448'), (2101, 'click', '212,448,300'),
             (4501, 'move', '62,100'), (4601, 'click', '62,100,300'),
             (7001, 'move', '360,20'), (7101, 'click', '360,20,300'), (9001, 'shot', '0,0'),
             (10001, 'move', '75,448'), (11001, 'click', '75,448,1000'),
             (16001, 'move', '275,95'), (17001, 'click', '275,95,1000'),
             (30001, 'move', '280,41'), (31001, 'click', '280,41,300')]
    items += [(33001 + 300*i, 'key', '8') for i in range(10)]
    items += [(36101 + 400*i, 'key', str(ord(ch.upper()))) for i, ch in enumerate(name)]
    end = 36101 + 400 * len(name)
    return numeric(items + [(end + 500, 'move', '550,40'), (end + 1500, 'click', '550,40,800'), (end + 5500, 'shot', '0,0')])


def reload_prefix():
    return story_route.R().at('S3510.CIF', 12000).clicks('212,448 shot 134,243 shot 212,448 62,100 360,20 shot', 8000).text()


def reload_payload():
    # The original prefix is unchanged; this explicit delta adds the final pair.
    return reload_prefix() + ';S3510.CIF+73000:move:320,60;S3510.CIF+76000:shot:0,0'


def send(session, payload):
    io.require(session.request_id < MAX_GLYPH_REQUESTS - 1, 'glyph request budget exhausted; finish reserved')
    return session.send(payload)


def play(session, known_hashes, name):
    observation, image = send(session, story_route.load_save_prefix() + ';' + board_prefix())
    io.require(observation['state'] == [3588, 3588, 0, -1]
               and observation['flags'].get(2001, 0) == 0 and observation['flags'].get(1418) == 1,
               'ordinary prefix did not reach a first-time glyph board')
    for attempt in range(48):
        if observation['flags'].get(2001, 0) == 1:
            break
        io.require(observation['state'] == [3588, 3588, 0, -1], 'natural glyph loss or unexpected active scene')
        try:
            board, hashes = glyph_pixels.read_board(image, known_hashes)
        except ValueError as error:
            io.write_json(session.out / f'rejected-capture-{attempt:02d}.json',
                          {'capture': image.name, 'sha256': io.digest(image), 'reason': str(error)})
            observation, image = send(session, '1:move:635,385;2500:shot:0,0')
            continue
        candidate = glyph_pixels.plan(board)
        events = glyph_pixels.events(candidate)
        io.write_json(session.out / f'plan-{attempt:02d}.json', {'capture': image.name,
                      'capture_sha256': io.digest(image), 'board': board, 'cell_hashes': hashes,
                      'candidate': candidate, 'events': events})
        observation, image = send(session, event_payload(events))
    else:
        io.require(observation['flags'].get(2001) == 1, 'bounded48 glyph attempts exhausted without a real win')
    io.require(observation['flags'].get(2001) == 1, 'no real glyph win')
    observation, image = send(session, continue_payload())
    io.require(observation['state'][0] in (1294, 1295) and observation['flags'].get(2001) == 1,
               'original win did not continue to the light handoff')
    observation, image = send(session, pickup_payload())
    io.require(observation['state'] == [1945, 1945, 0, -1] and observation['flags'].get(1357) == 1
               and observation['flags'].get(1418, 0) == 0, 'ordinary pickup did not earn the light grant')
    send(session, caption_payload())
    observation, image = send(session, bye_payload())
    io.require(observation['state'] == [3510, 3510, 4, -1], 'Bye/bag continuation differs')
    observation, image = send(session, inventory_save_payload(name))
    io.require(observation['state'] == [3510, 3510, 4, -1], 'original UI save did not return safely')


def verify_reload(session):
    _, one, zero = check_route.glyph_win_configuration()
    observations, clocks = session.observations, []
    io.require(len(observations) >= 5, 'reload observations incomplete')
    for observation in observations:
        state, values = observation['state'], observation['flags']
        io.require(state[:3] == [3510, 3510, 4], 'reload safe scene/view differs')
        io.require((one | zero) <= check_route.flag_scope(observation['scope'])
                   and all(values.get(f, 0) == 1 for f in one)
                   and all(values.get(f, 0) == 0 for f in zero), 'reload reward/prerequisite/zero proof differs')
        raw_scope = check_route.flag_scope(observation['scope'], include_clock=True)
        clock = {'total_minutes': (values.get(338, 0) >> 16) | ((values.get(339, 0) & 65535) << 16),
                 'hour': values.get(340, 0) & 65535, 'minute': values.get(339, 0) >> 16,
                 'day': values.get(340, 0) >> 16}
        clocks.append((raw_scope & check_route.CLOCK_OVERLAP_DIAGNOSTICS, clock))
    check_route.verify_clock_diagnostics(clocks)
    io.require([o['state'][3] for o in observations if o['state'][3] != -1] == [4], 'reload did not select actual4')
    io.require(all(o['state'] == [3510, 3510, 4, -1] for o in observations[-2:]), 'reload final safe pair missing')


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('native', 'game-exe', 'game-data', 'source-save', 'atlas'):
        parser.add_argument('--' + name, type=Path, required=True)
    for name in ('native-sha256', 'save-sha256', 'atlas-sha256'):
        parser.add_argument('--' + name, required=True)
    parser.add_argument('--save-name', default='m29')
    parser.add_argument('--output', type=Path, help='new retained evidence directory; default new scratch directory')
    parser.add_argument('--timeout', type=int, default=180, help='1-180 seconds per session')
    args = parser.parse_args(argv)
    out, receipt = None, {'accepted': False}
    try:
        for name in ('native', 'game_exe', 'game_data', 'source_save', 'atlas'):
            setattr(args, name, getattr(args, name).resolve(strict=True))
        io.require(1 <= args.timeout <= 180, 'timeout must be1-180 seconds')
        inventory_save_payload(args.save_name)
        io.require(args.source_save.name.lower() not in (args.save_name + '.sav', 'continue.sav'), 'invalid canonical source/save name')
        io.require(args.native_sha256 != io.ORIGINAL_SHA256 and io.digest(args.native) == args.native_sha256
                   and io.digest(args.source_save) == args.save_sha256, 'reviewed native/source pins differ')
        io.require(io.digest(args.game_exe) == io.ORIGINAL_SHA256 and io.digest(args.game_data / 'GAME.EXE') == io.ORIGINAL_SHA256,
                   'original data image pin differs')
        io.require(not (args.game_data / 'Documents5').exists()
                   and not any(path.is_symlink() for path in args.game_data.rglob('*')), 'seed contains saves or symlinks')
        initial = source_state(args.source_save)
        known_hashes = glyph_pixels.load_atlas(args.atlas, args.atlas_sha256)
        target = args.output.resolve() if args.output else Path(tempfile.mkdtemp(prefix='blackmoor-glyph-'))
        io.require(not (target == args.game_data or args.game_data in target.parents or target == args.source_save.parent
                        or args.source_save.parent in target.parents), 'output must be outside supplied data/save directories')
        if args.output:
            target.mkdir(parents=True, exist_ok=False)
        out = target
        protected = {str(path): io.digest(path) for path in (args.native, args.game_exe, args.source_save, args.atlas,
                     args.game_data / 'GAME.EXE', args.game_data / 'Game.ini', args.game_data / 'Ciftree' / 'CIFTREE.DAT',
                     Path(__file__), Path(glyph_pixels.__file__), Path(io.__file__), Path(check_route.__file__), Path(story_route.__file__))}
        receipt.update(native_sha256=args.native_sha256, source_sha256=args.save_sha256, atlas_sha256=args.atlas_sha256,
                       protected_inputs=protected, source_state=initial, RC_FLAGS=rc_flags(), glyph_attempts=48,
                       glyph_requests_including_finish=64, timeout_seconds=args.timeout,
                       scope='one first-time Junior game; no repeat/Senior or all-board guarantee')
        io.write_json(out / 'receipt.json', receipt)
        producer = io.Session(args, out / 'producer', args.source_save, rc_flags=rc_flags())
        error = None
        try:
            play(producer, known_hashes, args.save_name)
        except (Exception, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        finally:
            producer.close(error)
        io.require(producer.receipt['wall_seconds'] <= args.timeout, 'producer exceeded glyph deadline')
        saved = producer.saves / (args.save_name + '.SAV')
        checked = check_route.verify((producer.out / 'run.log').read_text(), saved, 'glyph-win')
        _, one, zero = check_route.glyph_win_configuration()
        saved_state = io.save_state(saved, progression_flags=one | zero)
        io.require(saved_state['difficulty'] == 0 and [saved_state[k] for k in ('scene', 'art', 'view', 'held')] == [3510, 3510, 4, -1]
                   and all(saved_state['progression'][f] == 1 for f in one)
                   and all(saved_state['progression'][f] == 0 for f in zero), 'actual UI save state/reward differs')
        reload = io.Session(args, out / 'reload', saved, rc_flags=rc_flags())
        error = None
        try:
            send(reload, story_route.load_save_prefix() + ';' + reload_payload())
        except (Exception, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        finally:
            reload.close(error)
        io.require(reload.receipt['wall_seconds'] <= args.timeout, 'reload exceeded glyph deadline')
        verify_reload(reload)
        io.require(all(io.digest(Path(path)) == pin for path, pin in protected.items()), 'protected source/native/tool/atlas input changed')
        accepted = out / saved.name
        io.require(not accepted.exists(), 'refuse accepted checkpoint overwrite')
        shutil.copy2(saved, accepted)
        io.require(io.digest(accepted) == io.digest(saved) == io.digest(reload.copy), 'canonical UI output/reload copy hashes differ')
        receipt.update(accepted=True, result=checked, output_save=str(accepted), output_save_sha256=io.digest(accepted),
                       producer_receipt_sha256=io.digest(producer.out / 'receipt.json'), reload_receipt_sha256=io.digest(reload.out / 'receipt.json'),
                       producer_initial_saves=[args.source_save.name], reload_initial_saves=[saved.name],
                       producer_final_saves={path.name: io.digest(path) for path in producer.saves.glob('*.SAV')},
                       reload_final_saves={path.name: io.digest(path) for path in reload.saves.glob('*.SAV')},
                       reload_delta='unchanged accepted prefix plus center73000/shot76000; no generated continue save used as canonical')
        io.write_json(out / 'receipt.json', receipt)
        print(json.dumps({'accepted': True, 'receipt': str(out / 'receipt.json'), 'save_sha256': receipt['output_save_sha256']}))
        return 0
    except (Exception, KeyboardInterrupt) as error:
        receipt.update(error=str(error) or type(error).__name__)
        if out is not None:
            io.write_json(out / 'receipt.json', receipt)
        print(json.dumps({'accepted': False, 'error': receipt['error'], 'evidence': str(out) if out else None}))
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
