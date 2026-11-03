#!/usr/bin/env python3
"""One first-time Junior OCR or explicit Senior key-cycle typing game.

Actual captured pixels choose ordinary spaced VKs. Original game code alone
owns balloons, pending keys, score, timer, win, clock reset and crest reward.
Geometry/OCR assets are caller-owned pinned inputs, never distributed here.
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
import typing_ocr
import typing_keycycle as senior

MAX_REQUESTS = 64


def crest_owned(path):
    data = path.read_bytes()
    io.require(len(data) == 170770, 'unexpected save length')
    return struct.unpack_from('<I', data, 0x2ba + 4*2)[0]


def source_state(path, expected_difficulty=0, expected_clock=None):
    io.require(type(expected_difficulty) is int and expected_difficulty in (0, 2), 'unsupported typing difficulty')
    _, one, zero = check_route.typing_crest_configuration('corbin-portrait')
    state = io.save_state(path, progression_flags=one | zero | {1672})
    io.require(state['difficulty'] == expected_difficulty and [state[k] for k in ('scene', 'art', 'view', 'held')] == [2741, 2741, 0, -1]
               and all(state['progression'][f] == 1 for f in one | {1672})
               and all(state['progression'][f] == 0 for f in zero) and crest_owned(path) == 0,
               'source must be observed first-time '+('Junior' if expected_difficulty == 0 else 'Senior')+' m45 with Corbin known and no crest2/previous typing attempt')
    data = path.read_bytes()
    clock = {k: struct.unpack_from(fmt, data, offset)[0] for k, fmt, offset in (
        ('total_minutes', '<I', 0x2430), ('minute', '<H', 0x2434), ('hour', '<H', 0x2436), ('day', '<H', 0x2438))}
    if expected_difficulty == 0:
        io.require(expected_clock is None and clock['day'] == 3 and clock['hour'] == 16 and 0 <= clock['minute'] < 60
                   and clock['total_minutes'] == clock['hour']*60 + clock['minute'], 'source clock gate differs')
    else:
        senior.check_clock(expected_clock)
        io.require(clock == expected_clock, 'actual Senior source clock differs from the pinned profile')
    state['clock_diagnostics'] = clock
    return state


def rc_flags():
    _, one, zero = check_route.typing_crest_configuration('typing-crest')
    runs = []
    for value in sorted(one | zero | set(range(338, 342))):
        if runs and value == runs[-1][1] + 1:
            runs[-1][1] = value
        else:
            runs.append([value, value])
    return ','.join(str(a) if a == b else f'{a}-{b}' for a, b in runs)


def send(session, payload):
    io.require(session.request_id < MAX_REQUESTS - 1, 'typing request budget exhausted; finish reserved')
    return session.send(payload)


def play(session, rects, ocr_tool, ocr_data, name, *, key_cycle=None):
    prefix = story_route.leg_typing_start()
    if key_cycle is not None:
        io.require(prefix.endswith('S1340.CIF+1000:shot:0,0'), 'typing entry capture changed')
        prefix = prefix.removesuffix('S1340.CIF+1000:shot:0,0') + 'S1340.CIF+1500:shot:0,0'
    observation, image = send(session, story_route.load_save_prefix() + ';' + prefix)
    io.require(observation['state'] == [1340, 1340, 0, -1] and observation['flags'].get(2088) == 1
               and observation['flags'].get(2014, 0) == observation['flags'].get(1687, 0) == 0,
               'first-time question did not reach a live selected board without an abandoned attempt')
    for iteration in range(48 if key_cycle is None else senior.MAX_CYCLES):
        if observation['flags'].get(2014) == 1:
            break
        io.require(observation['state'] == [1340, 1340, 0, -1], 'natural typing loss/incomplete or unexpected scene')
        if key_cycle is None:
            record = typing_ocr.analyse(image, session.out, iteration, rects, ocr_tool, ocr_data)
            payload = typing_ocr.key_payload(record['letters'])
        else:
            payload = key_cycle
        observation, image = send(session, payload)
    io.require(observation['flags'].get(2014) == 1 and '\\S1343.CIF' in (session.out / 'run.log').read_text(),
               'no actual original2014/1343 win within the selected bounded key batches')
    if key_cycle is not None:
        senior.check_full_quiz((session.out / 'run.log').read_text())
    observation, _ = send(session, story_route.typing_continue_payload())
    io.require(observation['state'] == [4138, 4138, 0, -1] and observation['flags'].get(1672, 0) == 0,
               'original win did not complete the authored Nigel/clock continuation')
    send(session, story_route.typing_pickup_payload())
    send(session, story_route.typing_flip_bag_payload())
    observation, _ = send(session, story_route.typing_examine_payload())
    io.require(observation['state'] == [6200, 6200, 0, -1], 'actual inventory crest2 examination did not open6200')
    observation, _ = send(session, story_route.typing_close_payload())
    io.require(observation['state'] == [4114, 4114, 0, -1], 'examination pop/X did not return safely; no PUT is sent')
    observation, _ = send(session, story_route.ethel_save_payload(name))
    io.require(observation['state'] == [4114, 4114, 0, -1], 'original typing reward UI save did not return safely')


def verify_reload(session):
    _, one, zero = check_route.typing_crest_configuration('typing-crest')
    io.require(len(session.observations) >= 5 and any(o['state'] == [6200, 6200, 0, -1] for o in session.observations),
               'reload did not examine actual crest2')
    clocks = []
    for observation in session.observations:
        values, state = observation['flags'], observation['state']
        io.require(state[0] in (4114, 6200) and state[1] == state[0] and state[2:] == [0, -1],
                   'typing reload scene/view/held differs; crest2 is not a held item')
        scope = check_route.flag_scope(observation['scope'], include_clock=True)
        io.require((one | zero) <= scope and all(values.get(f, 0) == 1 for f in one)
                   and all(values.get(f, 0) == 0 for f in zero), 'typing reload scoped prerequisites/zeros differ')
        clock = {'total_minutes': (values.get(338, 0) >> 16) | ((values.get(339, 0) & 65535) << 16),
                 'hour': values.get(340, 0) & 65535, 'minute': values.get(339, 0) >> 16,
                 'day': values.get(340, 0) >> 16}
        clocks.append((scope & check_route.CLOCK_OVERLAP_DIAGNOSTICS, clock))
    check_route.verify_clock_diagnostics(clocks)
    io.require(all(o['state'] == [4114, 4114, 0, -1] for o in session.observations[-2:]), 'typing reload final safe pair missing')


def argument_parser(profile='junior'):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--profile', choices=('junior', 'senior'), default='junior')
    for name in ('native', 'game-exe', 'game-data', 'source-save'):
        parser.add_argument('--' + name, type=Path, required=True)
    for name in ('native-sha256', 'save-sha256'):
        parser.add_argument('--' + name, required=True)
    for name in ('geometry', 'ocr-tool', 'ocr-data'):
        parser.add_argument('--' + name, type=Path, required=profile == 'junior')
    for name in ('geometry-sha256', 'ocr-tool-sha256', 'ocr-data-sha256'):
        parser.add_argument('--' + name, required=profile == 'junior')
    parser.add_argument('--source-profile', type=Path, required=profile == 'senior')
    parser.add_argument('--source-profile-sha256', required=profile == 'senior')
    parser.add_argument('--save-name', default='m47')
    parser.add_argument('--output', type=Path, help='new retained evidence directory; default new scratch directory')
    parser.add_argument('--timeout', type=int, default=300, help='1-300 seconds per session')
    return parser


def main(argv=None):
    selector = argparse.ArgumentParser(add_help=False)
    selector.add_argument('--profile', choices=('junior', 'senior'), default='junior')
    selected, _ = selector.parse_known_args(argv)
    args = argument_parser(selected.profile).parse_args(argv)
    out, receipt = None, {'accepted': False}
    try:
        resources = ('geometry', 'ocr_tool', 'ocr_data') if args.profile == 'junior' else ('source_profile',)
        for name in ('native', 'game_exe', 'game_data', 'source_save') + resources:
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
        key_cycle = None
        if args.profile == 'junior':
            io.require(args.source_profile is None and args.source_profile_sha256 is None, 'source profile is Senior-only')
            initial = source_state(args.source_save)
            rects = typing_ocr.load_geometry(args.geometry, args.geometry_sha256)
            io.require(args.ocr_data.name == 'eng.traineddata' and io.digest(args.ocr_tool) == args.ocr_tool_sha256
                       and io.digest(args.ocr_data) == args.ocr_data_sha256, 'OCR executable/English data pins differ')
        else:
            profile = senior.load_profile(args.source_profile, args.source_profile_sha256, args.save_sha256)
            initial = source_state(args.source_save, expected_difficulty=2, expected_clock=profile['clock'])
            rects = None
            key_cycle = senior.payload()
        target = args.output.resolve() if args.output else Path(tempfile.mkdtemp(prefix='blackmoor-typing-'))
        io.require(not (target == args.game_data or args.game_data in target.parents or target == args.source_save.parent
                        or args.source_save.parent in target.parents), 'output must be outside supplied data/save directories')
        if args.output:
            target.mkdir(parents=True, exist_ok=False)
        out = target
        extra = ((args.geometry, args.ocr_tool, args.ocr_data) if args.profile == 'junior'
                 else (args.source_profile, senior.CYCLE_PATH))
        protected = {str(p): io.digest(p) for p in (args.native, args.game_exe, args.source_save,
                     args.game_data / 'GAME.EXE', args.game_data / 'Game.ini', args.game_data / 'Ciftree' / 'CIFTREE.DAT',
                     Path(__file__), Path(typing_ocr.__file__), Path(senior.__file__), Path(io.__file__), Path(check_route.__file__), Path(story_route.__file__)) + extra}
        receipt.update(native_sha256=args.native_sha256, source_sha256=args.save_sha256, protected_inputs=protected,
                       source_state=initial, RC_FLAGS=rc_flags(), typing_batches=(48 if key_cycle is None else senior.MAX_CYCLES), requests_including_finish=64,
                       geometry_sha256=args.geometry_sha256, ocr_tool_sha256=args.ocr_tool_sha256, ocr_data_sha256=args.ocr_data_sha256,
                       timeout_seconds=args.timeout, profile=args.profile, keycycle_sha256=(senior.CYCLE_SHA256 if key_cycle is not None else None),
                       scope='one first-time selected typing game; no all-deal/spacing guarantee')
        io.write_json(out / 'receipt.json', receipt)
        producer = io.Session(args, out / 'producer', args.source_save, rc_flags=rc_flags())
        error = None
        try:
            play(producer, rects, args.ocr_tool, args.ocr_data, args.save_name, key_cycle=key_cycle)
        except (Exception, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        finally:
            producer.close(error)
        io.require(producer.receipt['wall_seconds'] <= args.timeout, 'producer exceeded typing deadline')
        saved = producer.saves / (args.save_name + '.SAV')
        checked = check_route.verify((producer.out / 'run.log').read_text(), saved, 'typing-crest',
                                     typing_source_clock=(initial['clock_diagnostics'] if args.profile == 'senior' else None))
        _, one, zero = check_route.typing_crest_configuration('typing-crest')
        state = io.save_state(saved, progression_flags=one | zero)
        io.require(state['difficulty'] == initial['difficulty'] and [state[k] for k in ('scene', 'art', 'view', 'held')] == [4114, 4114, 0, -1]
                   and all(state['progression'][f] == 1 for f in one) and all(state['progression'][f] == 0 for f in zero),
                   'actual typing UI save state/flags differ')
        io.require(crest_owned(saved) == 1, 'actual UI save did not contain crest2')
        reload = io.Session(args, out / 'reload', saved, rc_flags=rc_flags())
        error = None
        try:
            send(reload, story_route.load_save_prefix() + ';' + story_route.typing_reload_payload())
        except (Exception, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        finally:
            reload.close(error)
        io.require(reload.receipt['wall_seconds'] <= args.timeout, 'reload exceeded typing deadline')
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
