#!/usr/bin/env python3
"""One first-paid Junior replacement glyph attempt through ordinary input.

Default: observed first-paid pending source. Optional rune-passage context
starts from the genuine afternoon3335/held5 wait checkpoint; no abandoned
pending game is needed. No atlas/asset payload ships.
The original game owns every swap, timer, reward and save. Preexisting2001
is never this round's win proof. Other replacement/list variants are unverified.
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
import glyph_live as first
import glyph_pixels
import story_route

send = first.send


def inventory(path):
    """Read-only original save item-presence cells for fresh4, used5 and13.

    Original save data begins at0x62; these cells are global583bd5 +4*item
    relative to saved block58397d. No save serialization is performed.
    """
    data = path.read_bytes()
    io.require(len(data) == 170770, 'unexpected save length')
    return {i: struct.unpack_from('<I', data, 0x2ba + 4*i)[0] for i in (4, 5, 13)}


def configuration(context='first-paid'):
    if context == 'first-paid':
        return check_route.word_lock_configuration('repeat-glyph-win')
    io.require(context == 'rune-passage', 'unknown repeat context')
    return check_route.rune_light_configuration('rune-light-replacement')


def rune_source_state(path):
    _, one, zero = check_route.rune_light_configuration('rune-light-wait')
    state = io.save_state(path, progression_flags=one | zero)
    items = inventory(path)
    data = path.read_bytes()
    bag = {i: struct.unpack_from('<I', data, 0x2ba + 4*i)[0] for i in range(40)}
    expected_bag = {2, 6, 7, 11, 12, 16, 17, 19, 20, 21}
    io.require(all(value == int(i in expected_bag) for i, value in bag.items()),
               'post-rune source bag differs from the observed ten-item inventory layout')
    io.require(state['difficulty'] == 0 and [state[k] for k in ('scene', 'art', 'view', 'held')] == [3335, 3335, 0, 5]
               and all(state['progression'][f] == 1 for f in one)
               and all(state['progression'][f] == 0 for f in zero)
               and items == {4: 0, 5: 0, 13: 0} and struct.unpack_from('<I', data, 0x2ba + 4*2)[0] == 1,
               'source must be the observed post-rune Junior afternoon wait checkpoint with real held5 and owned2')
    clock = {name: struct.unpack_from(fmt, data, offset)[0] for name, fmt, offset in (
        ('total_minutes', '<I', 0x2430), ('minute', '<H', 0x2434), ('hour', '<H', 0x2436), ('day', '<H', 0x2438))}
    io.require(clock['day'] == 3 and 14 <= clock['hour'] < 21 and 0 <= clock['minute'] < 60
               and clock['total_minutes'] == clock['hour'] * 60 + clock['minute'], 'source afternoon door clock gate differs')
    state.update(clock_diagnostics=clock, inventory=items, bag_item_ids=sorted(expected_bag))
    return state


def source_state(path, context='first-paid'):
    if context == 'rune-passage':
        return rune_source_state(path)
    io.require(context == 'first-paid', 'unknown repeat context')
    _, one, zero = check_route.word_lock_configuration('paid-light-request')
    state = io.save_state(path, progression_flags=one | zero)
    pending = (state['difficulty'] == 0 and [state[k] for k in ('scene', 'art', 'view', 'held')] == [3510, 3510, 4, -1]
               and all(state['progression'].get(f) == 1 for f in one)
               and all(state['progression'].get(f) == 0 for f in zero)
               and inventory(path) == {4: 0, 5: 1, 13: 0})
    io.require(pending, 'source must be the observed first-paid pending Junior shape with used5; first-time/Senior/later sources refused')
    data = path.read_bytes()
    clock = {name: struct.unpack_from(fmt, data, offset)[0] for name, fmt, offset in (
        ('total_minutes', '<I', 0x2430), ('minute', '<H', 0x2434), ('hour', '<H', 0x2436), ('day', '<H', 0x2438))}
    io.require(clock['day'] == 3 and clock['hour'] == 14 and 0 <= clock['minute'] < 60
               and clock['total_minutes'] == clock['hour'] * 60 + clock['minute'], 'source clock gate differs')
    state.update(clock_diagnostics=clock, inventory=inventory(path))
    return state


def rc_flags(context='first-paid'):
    _, one, zero = configuration(context)
    runs = []
    for value in sorted(one | zero | set(range(338, 342))):
        if runs and value == runs[-1][1] + 1:
            runs[-1][1] = value
        else:
            runs.append([value, value])
    return ','.join(str(a) if a == b else f'{a}-{b}' for a, b in runs)


def has_fresh_win(log):
    """This process must open a new board and then the actual1299 win scene."""
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    return 3588 in opened and 1299 in opened[opened.index(3588) + 1:]


def caption_payload():
    items = [(1, 'move', '22,405'), (1001, 'click', '22,405,6000')]
    items += [(1501 + 400*j, 'move', f'22,{y}') for j, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455))]
    return first.numeric(items + [(5501, 'move', '22,456'), (9001, 'shot', '0,0')])


def bye_payload():
    return ('1:move:150,438;101:click:150,438,600;15001:shot:0,0;'
            '18001:move:212,448;19001:click:212,448,600;22001:shot:0,0')


def inventory_payload():
    return ('1:move:60,100;101:click:60,100,600;2501:shot:0,0;'
            '4001:move:212,448;4101:click:212,448,300;6501:move:62,100;6601:click:62,100,300;'
            '9001:move:360,20;9101:click:360,20,300;12001:shot:0,0')


def rune_inventory_payload():
    # Exact successful private m51 request25: actual fresh4, then reopen bag.
    return ('1:move:60,100;1001:click:60,100,600;5001:shot:0,0;'
            '7001:move:212,448;8001:click:212,448,600;12001:shot:0,0')


def rune_put_payload():
    # Exact request26:134,310 is empty after4 leaves this ten-item bag.
    return ('1:move:134,310;1001:click:134,310,600;5001:shot:0,0;'
            '7001:move:360,20;8001:click:360,20,600;12001:shot:0,0')


def rune_reload_payload():
    # Accepted m51 reload with owned2: actual4 at206,243, empty134,310.
    r = story_route.R().at('S3510.CIF', 12000).clicks('212,448', 0)
    r.at('S3510.CIF', 17000).clicks('shot', 0)
    r.at('S3510.CIF', 22000).clicks('206,243', 0)
    r.at('S3510.CIF', 27000).clicks('shot', 0)
    r.at('S3510.CIF', 32000).clicks('212,448 134,310 360,20', 5000)
    r.at('S3510.CIF', 47000).clicks('shot', 0)
    return r.text() + ';S3510.CIF+73000:move:320,60;S3510.CIF+76000:shot:0,0'


def save_payload(name):
    io.require(re.fullmatch('[a-z0-9]{1,10}', name) is not None and name != 'continue', 'invalid UI save name')
    payload = story_route.menu_to_save_screen('unused', 1000) + ';' + story_route.save_tail('unused', 19000, name)
    return re.sub(r'unused\+(\d+)', r'\1', payload)


def reload_payload():
    r = story_route.R().at('S3510.CIF', 12000).clicks('212,448', 0)
    r.at('S3510.CIF', 15500).clicks('shot', 0)
    r.at('S3510.CIF', 19000).clicks('134,243', 0)
    r.at('S3510.CIF', 22500).clicks('shot', 0)
    r.at('S3510.CIF', 26000).clicks('212,448 62,100 360,20', 3500)
    r.at('S3510.CIF', 36500).clicks('shot', 0)
    # Preserve the old prefix; add the public first-time final-pair observation.
    return r.text() + ';S3510.CIF+73000:move:320,60;S3510.CIF+76000:shot:0,0'


def rune_board_payload():
    # Same exercised play-button move/click gap and hold as board_prefix();
    # numeric offsets are relative to the already-observed3585 request shot.
    return ('1:move:480,152;1001:click:480,152,300;'
            'S3588.CIF+500:move:635,385;S3588.CIF+1000:shot:0,0')


def play(session, known_hashes, name, context='first-paid'):
    if context == 'rune-passage':
        observation, image = send(session, story_route.load_save_prefix() + ';' + story_route.leg_rune_light_start())
        io.require(observation['state'] == [3585, 3585, 0, -1]
                   and all(observation['flags'].get(f) == 1 for f in (2001, 1357, 1418, 1809)),
                   'ordinary later paid request did not reach3585')
        observation, image = send(session, rune_board_payload())
    else:
        io.require(context == 'first-paid', 'unknown repeat context')
        observation, image = send(session, story_route.load_save_prefix() + ';' + first.board_prefix())
    io.require(observation['state'] == [3588, 3588, 0, -1]
               and all(observation['flags'].get(f) == 1 for f in (2001, 1357, 1418, 1809)),
               'ordinary prefix did not reach the paid repeat board')
    for attempt in range(48):
        if observation['state'][0] in (1299, 1295) and has_fresh_win((session.out / 'run.log').read_text()):
            break
        io.require(observation['state'] == [3588, 3588, 0, -1], 'natural repeat loss or unexpected active scene')
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
        observation, image = send(session, first.event_payload(events))
    io.require(observation['state'][0] in (1299, 1295) and has_fresh_win((session.out / 'run.log').read_text()),
               'no fresh original1299 repeat win within48 attempts; old2001 is insufficient')
    observation, image = send(session, first.continue_payload())
    io.require(observation['state'] == [1295, 1295, 0, -1], 'fresh win did not continue to1295')
    observation, image = send(session, first.pickup_payload())
    io.require(observation['state'] == [1949, 1949, 0, -1]
               and all(observation['flags'].get(f, 0) == 0 for f in (1418, 1809, 2041, 2042)),
               'ordinary repeat pickup did not earn the fresh-light handoff')
    send(session, caption_payload())
    observation, image = send(session, bye_payload())
    io.require(observation['state'] == [3510, 3510, 4, -1], 'repeat Bye/bag continuation differs')
    if context == 'rune-passage':
        observation, image = send(session, rune_inventory_payload())
        io.require(observation['state'] == [3510, 3510, 4, 4], 'rune inventory did not select actual fresh4')
        observation, image = send(session, rune_put_payload())
    else:
        observation, image = send(session, inventory_payload())
    io.require(observation['state'] == [3510, 3510, 4, -1], 'actual light inventory/PUT/X continuation differs')
    observation, image = send(session, save_payload(name))
    io.require(observation['state'] == [3510, 3510, 4, -1], 'original UI save did not return safely')


def verify_reload(session, context='first-paid'):
    _, one, zero = configuration(context)
    observations, clocks = session.observations, []
    io.require(len(observations) >= 5, 'repeat reload observations incomplete')
    for observation in observations:
        state, values = observation['state'], observation['flags']
        io.require(state[:3] == [3510, 3510, 4], 'repeat reload safe scene/view differs')
        io.require((one | zero) <= check_route.flag_scope(observation['scope'])
                   and all(values.get(f, 0) == 1 for f in one)
                   and all(values.get(f, 0) == 0 for f in zero), 'repeat reload reward/prerequisite/zero proof differs')
        raw_scope = check_route.flag_scope(observation['scope'], include_clock=True)
        clock = {'total_minutes': (values.get(338, 0) >> 16) | ((values.get(339, 0) & 65535) << 16),
                 'hour': values.get(340, 0) & 65535, 'minute': values.get(339, 0) >> 16,
                 'day': values.get(340, 0) >> 16}
        clocks.append((raw_scope & check_route.CLOCK_OVERLAP_DIAGNOSTICS, clock))
    check_route.verify_clock_diagnostics(clocks)
    io.require([o['state'][3] for o in observations if o['state'][3] != -1] == [4], 'repeat reload did not select actual4')
    io.require(all(o['state'] == [3510, 3510, 4, -1] for o in observations[-2:]), 'repeat reload final safe pair missing')


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('native', 'game-exe', 'game-data', 'source-save', 'atlas'):
        parser.add_argument('--' + name, type=Path, required=True)
    for name in ('native-sha256', 'save-sha256', 'atlas-sha256'):
        parser.add_argument('--' + name, required=True)
    parser.add_argument('--context', choices=('first-paid', 'rune-passage'), default='first-paid',
                        help='existing pending first-paid source, or genuine post-rune3335/held5 afternoon checkpoint')
    parser.add_argument('--save-name', default='m38')
    parser.add_argument('--output', type=Path, help='new retained evidence directory; default new scratch directory')
    parser.add_argument('--timeout', type=int, default=300, help='1-300 seconds per session')
    args = parser.parse_args(argv)
    out, receipt = None, {'accepted': False}
    try:
        for name in ('native', 'game_exe', 'game_data', 'source_save', 'atlas'):
            setattr(args, name, getattr(args, name).resolve(strict=True))
        io.require(1 <= args.timeout <= 300, 'timeout must be1-300 seconds')
        save_payload(args.save_name)
        io.require(args.source_save.name.lower() not in (args.save_name + '.sav', 'continue.sav'), 'invalid canonical source/save name')
        io.require(args.native_sha256 != io.ORIGINAL_SHA256 and io.digest(args.native) == args.native_sha256
                   and io.digest(args.source_save) == args.save_sha256, 'reviewed native/source pins differ')
        io.require(io.digest(args.game_exe) == io.ORIGINAL_SHA256 and io.digest(args.game_data / 'GAME.EXE') == io.ORIGINAL_SHA256,
                   'original data image pin differs')
        io.require(not (args.game_data / 'Documents5').exists()
                   and not any(path.is_symlink() for path in args.game_data.rglob('*')), 'seed contains saves or symlinks')
        initial = source_state(args.source_save, args.context)
        known_hashes = glyph_pixels.load_atlas(args.atlas, args.atlas_sha256)
        target = args.output.resolve() if args.output else Path(tempfile.mkdtemp(prefix='blackmoor-repeat-glyph-'))
        io.require(not (target == args.game_data or args.game_data in target.parents or target == args.source_save.parent
                        or args.source_save.parent in target.parents), 'output must be outside supplied data/save directories')
        if args.output:
            target.mkdir(parents=True, exist_ok=False)
        out = target
        protected = {str(path): io.digest(path) for path in (args.native, args.game_exe, args.source_save, args.atlas,
                     args.game_data / 'GAME.EXE', args.game_data / 'Game.ini', args.game_data / 'Ciftree' / 'CIFTREE.DAT',
                     Path(__file__), Path(glyph_pixels.__file__), Path(first.__file__), Path(io.__file__), Path(check_route.__file__), Path(story_route.__file__))}
        receipt.update(native_sha256=args.native_sha256, source_sha256=args.save_sha256, atlas_sha256=args.atlas_sha256,
                       protected_inputs=protected, source_state=initial, RC_FLAGS=rc_flags(args.context), glyph_attempts=48, context=args.context,
                       glyph_requests_including_finish=64, timeout_seconds=args.timeout,
                       scope=('one first-paid Junior replacement; no Senior/later-repeat or all-board guarantee' if args.context == 'first-paid' else
                              'one observed post-rune Junior paid replacement; no Senior/further-repeat or all-board guarantee'))
        io.write_json(out / 'receipt.json', receipt)
        producer = io.Session(args, out / 'producer', args.source_save, rc_flags=rc_flags(args.context))
        error = None
        try:
            play(producer, known_hashes, args.save_name, args.context)
        except (Exception, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        finally:
            producer.close(error)
        io.require(producer.receipt['wall_seconds'] <= args.timeout, 'producer exceeded glyph deadline')
        saved = producer.saves / (args.save_name + '.SAV')
        route = 'repeat-glyph-win' if args.context == 'first-paid' else 'rune-light-replacement'
        checked = check_route.verify((producer.out / 'run.log').read_text(), saved, route)
        _, one, zero = configuration(args.context)
        saved_state = io.save_state(saved, progression_flags=one | zero)
        io.require(saved_state['difficulty'] == 0 and [saved_state[k] for k in ('scene', 'art', 'view', 'held')] == [3510, 3510, 4, -1]
                   and all(saved_state['progression'][f] == 1 for f in one)
                   and all(saved_state['progression'][f] == 0 for f in zero), 'actual UI save state/reward differs')
        io.require(inventory(saved) == {4: 1, 5: 0, 13: 0}, 'UI save did not replace used5 with actual fresh4')
        if args.context == 'rune-passage':
            io.require(struct.unpack_from('<I', saved.read_bytes(), 0x2ba + 4*2)[0] == 1, 'UI save lost retained crest2')
        reload = io.Session(args, out / 'reload', saved, rc_flags=rc_flags(args.context))
        error = None
        try:
            send(reload, story_route.load_save_prefix() + ';' + (rune_reload_payload() if args.context == 'rune-passage' else reload_payload()))
        except (Exception, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        finally:
            reload.close(error)
        io.require(reload.receipt['wall_seconds'] <= args.timeout, 'reload exceeded glyph deadline')
        verify_reload(reload, args.context)
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
                       reload_delta='unchanged first-paid reload prefix plus public center73000/shot76000 final pair; no continue input')
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
