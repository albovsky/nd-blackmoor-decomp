#!/usr/bin/env python3
"""One observed Ethel truth/curiosity/Bye leg using ordinary FIFO input.

The original game owns every dialogue, flag, clock and UI save. Four bounded
payloads replace historical manual gaps; unknown/list/timing outcomes refuse.
"""
import argparse
import json
from pathlib import Path
import shutil
import struct
import tempfile

import bul_live as io
import check_route
import story_route


def source_state(path):
    _, one, zero = check_route.crest_prerequisite_configuration('right-fire-panel')
    state = io.save_state(path, progression_flags=one | zero)
    io.require(state['difficulty'] == 0 and [state[k] for k in ('scene', 'art', 'view', 'held')] == [3141, 3141, 0, 4]
               and all(state['progression'][f] == 1 for f in one)
               and all(state['progression'][f] == 0 for f in zero), 'source must be the observed Junior right-fire partial m40')
    data = path.read_bytes()
    clock = {k: struct.unpack_from(fmt, data, offset)[0] for k, fmt, offset in (
        ('total_minutes', '<I', 0x2430), ('minute', '<H', 0x2434), ('hour', '<H', 0x2436), ('day', '<H', 0x2438))}
    io.require(clock['day'] == 3 and clock['hour'] == 15 and 0 <= clock['minute'] < 60
               and clock['total_minutes'] == clock['hour']*60 + clock['minute'], 'source clock gate differs')
    state['clock_diagnostics'] = clock
    return state


def rc_flags():
    _, one, zero = check_route.crest_prerequisite_configuration('ethel-interrogation')
    values = sorted(one | zero | set(range(338, 342)))
    runs = []
    for value in values:
        if runs and value == runs[-1][1] + 1:
            runs[-1][1] = value
        else:
            runs.append([value, value])
    return ','.join(str(a) if a == b else f'{a}-{b}' for a, b in runs)


def send(session, payload):
    io.require(session.request_id < 4, 'Ethel four-payload budget exhausted; finish reserved')
    return session.send(payload)


def play(session, name):
    observation, _ = send(session, story_route.load_save_prefix() + ';' + story_route.leg_ethel_start())
    io.require(observation['state'] == [1406, 1406, 0, -1] and observation['flags'].get(2154) == 1,
               'prefix did not reach the actual truthful reply and curiosity list')
    observation, _ = send(session, story_route.ethel_curiosity_payload())
    io.require(observation['state'] == [1407, 1407, 0, -1] and observation['flags'].get(2154) == 1,
               'curiosity reply did not reach the actual Bye list')
    observation, _ = send(session, story_route.ethel_bye_payload())
    io.require(observation['state'] == [3428, 3428, 0, -1], 'actual Bye did not return safely')
    observation, _ = send(session, story_route.ethel_save_payload(name))
    io.require(observation['state'] == [3428, 3428, 0, -1], 'original UI save did not return safely')


def verify_reload(session):
    _, one, zero = check_route.crest_prerequisite_configuration('ethel-interrogation')
    io.require(len(session.observations) >= 2, 'Ethel reload observations incomplete')
    clocks = []
    for observation in session.observations:
        values = observation['flags']
        io.require(observation['state'] == [3428, 3428, 0, -1], 'Ethel reload scene/art/held differs')
        scope = check_route.flag_scope(observation['scope'], include_clock=True)
        io.require((one | zero) <= scope and all(values.get(f, 0) == 1 for f in one)
                   and all(values.get(f, 0) == 0 for f in zero), 'Ethel reload scoped prerequisites/zeros differ')
        clock = {'total_minutes': (values.get(338, 0) >> 16) | ((values.get(339, 0) & 65535) << 16),
                 'hour': values.get(340, 0) & 65535, 'minute': values.get(339, 0) >> 16,
                 'day': values.get(340, 0) >> 16}
        clocks.append((scope & check_route.CLOCK_OVERLAP_DIAGNOSTICS, clock))
    check_route.verify_clock_diagnostics(clocks)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('native', 'game-exe', 'game-data', 'source-save'):
        parser.add_argument('--' + name, type=Path, required=True)
    for name in ('native-sha256', 'save-sha256'):
        parser.add_argument('--' + name, required=True)
    parser.add_argument('--save-name', default='m41')
    parser.add_argument('--output', type=Path, help='new retained evidence directory; default new scratch directory')
    parser.add_argument('--timeout', type=int, default=300, help='1-300 seconds per session')
    args = parser.parse_args(argv)
    out, receipt = None, {'accepted': False}
    try:
        for name in ('native', 'game_exe', 'game_data', 'source_save'):
            setattr(args, name, getattr(args, name).resolve(strict=True))
        io.require(1 <= args.timeout <= 300, 'timeout must be1-300 seconds')
        story_route.ethel_save_payload(args.save_name)
        io.require(args.source_save.name.lower() not in (args.save_name + '.sav', 'continue.sav'), 'invalid canonical source/save name')
        io.require(args.native_sha256 != io.ORIGINAL_SHA256 and io.digest(args.native) == args.native_sha256
                   and io.digest(args.source_save) == args.save_sha256, 'reviewed native/source pins differ')
        io.require(io.digest(args.game_exe) == io.ORIGINAL_SHA256 and io.digest(args.game_data / 'GAME.EXE') == io.ORIGINAL_SHA256,
                   'original data image pin differs')
        io.require(not (args.game_data / 'Documents5').exists() and not any(p.is_symlink() for p in args.game_data.rglob('*')),
                   'seed contains saves or symlinks')
        initial = source_state(args.source_save)
        target = args.output.resolve() if args.output else Path(tempfile.mkdtemp(prefix='blackmoor-ethel-'))
        io.require(not (target == args.game_data or args.game_data in target.parents or target == args.source_save.parent
                        or args.source_save.parent in target.parents), 'output must be outside supplied data/save directories')
        if args.output:
            target.mkdir(parents=True, exist_ok=False)
        out = target
        protected = {str(p): io.digest(p) for p in (args.native, args.game_exe, args.source_save,
                     args.game_data / 'GAME.EXE', args.game_data / 'Game.ini', args.game_data / 'Ciftree' / 'CIFTREE.DAT',
                     Path(__file__), Path(io.__file__), Path(check_route.__file__), Path(story_route.__file__))}
        receipt.update(native_sha256=args.native_sha256, source_sha256=args.save_sha256, protected_inputs=protected,
                       source_state=initial, RC_FLAGS=rc_flags(), producer_payloads=4, producer_requests_including_finish=5,
                       timeout_seconds=args.timeout, scope='one observed Junior Ethel truth/curiosity/Bye chain; no list/timing guarantee')
        io.write_json(out / 'receipt.json', receipt)
        producer = io.Session(args, out / 'producer', args.source_save, rc_flags=rc_flags())
        error = None
        try:
            play(producer, args.save_name)
        except (Exception, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        finally:
            producer.close(error)
        io.require(producer.receipt['wall_seconds'] <= args.timeout, 'producer exceeded Ethel deadline')
        saved = producer.saves / (args.save_name + '.SAV')
        checked = check_route.verify((producer.out / 'run.log').read_text(), saved, 'ethel-interrogation')
        _, one, zero = check_route.crest_prerequisite_configuration('ethel-interrogation')
        state = io.save_state(saved, progression_flags=one | zero)
        io.require(state['difficulty'] == 0 and [state[k] for k in ('scene', 'art', 'view', 'held')] == [3428, 3428, 0, -1]
                   and all(state['progression'][f] == 1 for f in one) and all(state['progression'][f] == 0 for f in zero),
                   'actual Ethel UI save state/flags differ')
        reload = io.Session(args, out / 'reload', saved, rc_flags=rc_flags())
        error = None
        try:
            send(reload, story_route.load_save_prefix() + ';' + story_route.ethel_reload_payload())
        except (Exception, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        finally:
            reload.close(error)
        io.require(reload.receipt['wall_seconds'] <= args.timeout, 'reload exceeded Ethel deadline')
        verify_reload(reload)
        io.require(all(io.digest(Path(p)) == pin for p, pin in protected.items()), 'protected source/native/tool input changed')
        accepted = out / saved.name
        io.require(not accepted.exists(), 'refuse accepted checkpoint overwrite')
        shutil.copy2(saved, accepted)
        io.require(io.digest(accepted) == io.digest(saved) == io.digest(reload.copy), 'canonical UI output/reload copy hashes differ')
        receipt.update(accepted=True, result=checked, output_save=str(accepted), output_save_sha256=io.digest(accepted),
                       producer_receipt_sha256=io.digest(producer.out / 'receipt.json'), reload_receipt_sha256=io.digest(reload.out / 'receipt.json'),
                       producer_initial_saves=[args.source_save.name], reload_initial_saves=[saved.name],
                       producer_final_saves={p.name: io.digest(p) for p in producer.saves.glob('*.SAV')},
                       reload_final_saves={p.name: io.digest(p) for p in reload.saves.glob('*.SAV')})
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
