#!/usr/bin/env python3
"""One optional CakeMixing attempt from either pinned afternoon source.

Ordinary input only: the original game owns ingredients, baking and rewards.
Requires a reviewed native host, owner's data and an original-UI source save.
Unknown states refuse acceptance; there is no automatic retry.
"""
import argparse
import ast
import hashlib
import json
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys

import bul_live as io
import story_route

require = io.require
NATIVE_SHA256 = 'b49eaa71885a02e9e096b9766f020576ef0a0381837cd036f0875bab49351e24'
ORIGINAL_SHA256 = io.ORIGINAL_SHA256
CONTAINER_SHA256 = '1e865b13a4c0cf13568fc312f48de6c5e2acb0278b933b2a972b6c1dce456161'
INI_SHA256 = 'f8f892e828eca6086f5a25720e5e8e0c2ebbb7d81f1bb90bb8b73ea244419c79'
IO_SHA256 = '3a52e04b8bf642d90c3f00382fdc7b00c62791ad9f5a77fdf1cf6d81f933591d'
AUTHORED_AUXILIARY = 'HICONTINUECHEAT.SAV'
FLAGS = '1338,1421,1487,1502,1503,1567,1779,1797,1890'
EFFECTIVE_SCENES = (3510, 3520, 3554, 3563, 3583, 3584, 3592,
                    3600, 3601, 3602, 3603, 3604, 3605, 3606, 3607)
PROFILES = {'senior': {'source_name': 's57.SAV',
            'save': {'sha256': 'b0b49b4ca3692367e8da83c5a5b54957fed33a56e1aaaed68e3b26c01b0f9bb6'},
            'state': {'difficulty': 2,
                      'scene': 3510,
                      'art': 3510,
                      'view': 4,
                      'held': -1,
                      'clock': {'total_minutes': 876, 'minute': 36, 'hour': 14, 'day': 3}}},
 'junior': {'source_name': 'm51.SAV',
            'save': {'sha256': 'ca0793b073a6358da3e3d58b3cda6ed3ce99875a50988cdeca77c6b7db6a5678'},
            'state': {'difficulty': 0,
                      'scene': 3510,
                      'art': 3510,
                      'view': 4,
                      'held': -1,
                      'clock': {'total_minutes': 897, 'minute': 57, 'hour': 14, 'day': 3}}}}
STORY_API_SHA256 = {'R': 'c7304f95c218ad4f7824b9705b2f10b1d211b6ecdd4d874b64741d881cc706cd',
 'save_tail': '7a40e1e70461dc61d598bcad50edf56fd96d32ce37d968f0b71115968959f897',
 'menu_to_save_screen': '64cd56117a06c069d56cbf7252750e38e031d02f71ff530f3272f4fe0314bbfd',
 'load_save_prefix': '8e42f8ee67caf7ffc48080cede06c3be54a463c5d2de548200087e9c034c4d3e'}



def verify_shared_helpers():
    """Reuse the exact IO module and four exercised original-UI helpers.

    Unrelated route additions may change story_route's whole-file hash. These
    four definitions must retain their exact source; all whole-file versions
    are also recorded in the receipt. Session/PPM/FIFO are never forked here.
    """
    require(io.digest(Path(io.__file__)) == IO_SHA256, 'shared IO source pin differs')
    text = Path(story_route.__file__).read_text()
    nodes = {node.name: hashlib.sha256(ast.get_source_segment(text, node).encode()).hexdigest()
             for node in ast.parse(text).body
             if isinstance(node, (ast.FunctionDef, ast.ClassDef)) and node.name in STORY_API_SHA256}
    require(nodes == STORY_API_SHA256, 'shared original-UI helper source differs')
    return {'bul_live.py': io.digest(Path(io.__file__)),
            'story_route.py': io.digest(Path(story_route.__file__)),
            'check_route.py': io.digest(Path(io.check_route.__file__)),
            'story_api_sha256': nodes}


def source_guard(args):
    """Read-only preflight, before any directory creation or native launch."""
    profile = PROFILES[args.profile]
    require(sys.platform == 'darwin', 'fresh APFS clone workflow requires macOS')
    require(1 <= args.timeout <= 300, 'timeout must be 1-300 seconds')
    require(re.fullmatch('[a-z0-9]{1,10}', args.save_name) is not None,
            'invalid new optional save name')
    require(args.save_name not in ('s57', 'm51'), 'campaign source name cannot be reused')
    require(args.source_save.name == profile['source_name'], 'source profile filename differs')
    require(args.save_sha256 == profile['save']['sha256'] == io.digest(args.source_save),
            'genuine source profile pin differs')
    require(args.native_sha256 == NATIVE_SHA256 == io.digest(args.native),
            'reviewed native pin differs; no cross-build equivalence assumed')
    require(io.digest(args.game_exe) == ORIGINAL_SHA256
            and io.digest(args.game_data / 'GAME.EXE') == ORIGINAL_SHA256,
            'original data image pin differs')
    require(io.digest(args.game_data / 'Game.ini') == INI_SHA256
            and io.digest(args.game_data / 'Ciftree/CIFTREE.DAT') == CONTAINER_SHA256,
            'exercised data/configuration pin differs')
    require(not (args.game_data / 'Documents5').exists(), 'data seed contains saves')
    require(not any(p.is_symlink() for p in args.game_data.rglob('*')), 'data seed contains symlinks')
    loose = {p.name.lower() for p in (args.game_data / 'Ciftree').iterdir()}
    require(not any(f's{scene}.cif' in loose for scene in EFFECTIVE_SCENES),
            'unexpected effective loose scene override')
    state = snapshot(args.source_save)
    validate_profile_state(state, profile)
    return state, verify_shared_helpers()


def validate_profile_state(state, profile):
    expected = profile['state']
    require([state[k] for k in ['difficulty', 'scene', 'art', 'view', 'held']] == [expected[k] for k in ['difficulty', 'scene', 'art', 'view', 'held']], 'source profile difficulty/room/view/held differs')
    require(state['clock_diagnostics'] == expected['clock'], 'source profile clock differs')
    require(state['owned_cake_items'] == {'0': False, '1': False}, 'source already owns a cake')
    require(state['progression'] == {1338: 0, 1502: 0, 1503: 0, 1567: 1}, 'source profile oven/entry flags differ')
    return True


def classify_save_hashes(observed, required):
    require(required and AUTHORED_AUXILIARY not in required, 'authored auxiliary cannot be a source, output or checkpoint')
    for name, digest_value in list(observed.items()) + list(required.items()):
        require(Path(name).name == name and name.lower().endswith('.sav') and (re.fullmatch('[0-9a-f]{64}', digest_value) is not None), 'invalid save metadata')
    require(set(required) <= set(observed), 'required source/output save absent')
    require(set(observed) <= set(required) | {AUTHORED_AUXILIARY}, 'unexpected additional save')
    require(all((observed[n] == h for n, h in required.items())), 'required source/output copy digest differs')
    return {'required_saves': dict(required), 'authored_auxiliary_saves': {AUTHORED_AUXILIARY: observed[AUTHORED_AUXILIARY]} if AUTHORED_AUXILIARY in observed else {}, 'auxiliary_is_canonical': False, 'auxiliary_used_as_input': False, 'allowed_extra_names': [AUTHORED_AUXILIARY]}


def item(data, i):
    return struct.unpack_from('<I', data, 0x2ba + 4 * i)[0] == 1 or struct.unpack_from('<h', data, 0x10e)[0] == i


def snapshot(path):
    data = path.read_bytes()
    s = io.save_state(path, progression_flags=[1338, 1502, 1503, 1567])
    s['clock_diagnostics'] = {n: struct.unpack_from(f, data, o)[0] for n, f, o in [('total_minutes', '<I', 0x2430), ('minute', '<H', 0x2434), ('hour', '<H', 0x2436), ('day', '<H', 0x2438)]}
    s['owned_cake_items'] = {str(i): item(data, i) for i in [0, 1]}
    return s


def clicked(x, y, delay=6000):
    return f'1:move:{x},{y};1001:click:{x},{y},300;{delay}:shot:0,0'


def note(session, tag, result):
    obs, image = result
    io.ppm(image)
    with (session.out / 'stages.jsonl').open('a') as f:
        f.write(json.dumps({'tag': tag, 'observation': obs, 'capture': image.name, 'capture_sha256': io.digest(image)}) + '\n')
    return obs


def wait_for(session, scene, *, one=(), zero=(), tag='settle', rounds=6):
    for n in range(rounds):
        obs = note(session, tag + str(n), session.shot(6000))
        if obs['state'][:2] == [scene, scene] and all((obs['flags'].get(f, 0) == 1 for f in one)) and all((obs['flags'].get(f, 0) == 0 for f in zero)):
            return obs
    raise ValueError('Authored expected state not reached: ' + str(scene))


def relative_save(name):
    text = story_route.menu_to_save_screen('S3520.CIF', 1000) + ';' + story_route.save_tail('S3520.CIF', 17000, name)
    return ';'.join((x.split('+', 1)[1] for x in text.split(';')))


def right_turn():
    text = story_route.R().at('S3510.CIF', 1).turns('right', 1).text()
    return ';'.join((step.split('+', 1)[1] for step in text.split(';'))) + ';2501:shot:0,0'


def play(session, name):
    obs = note(session, 'fresh ordinary source Load', session.send(story_route.load_save_prefix() + ';S3510.CIF+30000:shot:0,0'))
    io.require(obs['state'] == [3510, 3510, 4, -1], 'unexpected loaded room/view/held')
    # Right band selects original state2: subtract one frame, then park.
    for wanted_view in [3, 2, 1, 0]:
        obs = note(session, 'right panorama to view' + str(wanted_view), session.send(right_turn()))
        io.require(obs['state'] == [3510, 3510, wanted_view, -1], 'ordinary right panorama view differs')
    obs = note(session, 'nook hotspot', session.send(clicked(488, 252)))
    io.require(obs['state'][:2] == [3520, 3520], 'nook not reached')
    note(session, 'microwave first instruction', session.send(clicked(303, 199, 30000)))
    wait_for(session, 3554, one=(1338,), tag='original first-use instruction return')
    note(session, 'oven permission hotspot', session.send(clicked(268, 282, 12000)))
    wait_for(session, 3600, tag='puzzle entry')
    note(session, 'type0 home first click', session.send(clicked(54, 88)))
    note(session, 'type0 large display second click', session.send(clicked(310, 170)))
    # Two MOVE events settle the original previous/current moving rectangles.
    drop = '1:move:269,299;1001:move:269,299;2001:click:269,299,300;6000:shot:0,0'
    obs = note(session, 'one allowed ingredient dropped', session.send(drop))
    io.require(obs['state'][:2] == [3600, 3600] and obs['flags'].get(1502) == 1 and (obs['flags'].get(1503) == 1), 'original nonempty/allowed-recipe flags absent; finish remains required')
    # Early1502/1503 express eligibility; original phase2 finish is mandatory.
    note(session, 'original oven finish', session.send(clicked(512, 276, 8000)))
    wait_for(session, 3605, one=(1502, 1503), tag='authored open-close oven continuation')
    note(session, 'ordinary microwave start button', session.send(clicked(581, 277, 12000)))
    wait_for(session, 3606, one=(1503,), tag='original timed baking completes')
    note(session, 'remove baking pan', session.send(clicked(485, 263)))
    wait_for(session, 3607, one=(1503,), tag='actual good cake closeup')
    note(session, 'physical cake pickup', session.send(clicked(334, 187)))
    # Original3554 clears these transient flags after physical pickup.
    wait_for(session, 3554, one=(1338,), zero=(1502, 1503), tag='authored flag reset after pickup')
    obs = note(session, 'safe nook return', session.send(clicked(311, 355)))
    io.require(obs['state'] == [3520, 3520, 0, -1], 'safe return differs')
    note(session, 'original UI save', session.send(relative_save(name)))


def original_path_check(log):
    scenes = [int(x) for x in re.findall('FILE open C:.*?\\\\S(\\d+)\\.CIF', log, re.I)]
    required = [3510, 3520, 3554, 3563, 3554, 3601, 3600, 3602, 3604, 3605, 3606, 3607, 3554, 3520]
    n = 0
    for sc in scenes:
        if n < len(required) and sc == required[n]:
            n += 1
    io.require(n == len(required), 'original cake continuation subsequence incomplete')
    return {'required': required, 'observed': scenes}


def save_catalog(session, required):
    observed = {f.name: io.digest(f) for f in session.saves.iterdir() if f.is_file() and f.suffix.lower() == '.sav'}
    record = classify_save_hashes(observed, required)
    record['all_save_hashes'] = observed
    record['source_copy_sha256'] = io.digest(session.copy)
    record['fresh_initial_contract'] = 'Unchanged pinned Session creates a fresh saves directory with exist_ok=False and copies only the supplied source before Popen; no auxiliary is ever an incoming source.'
    return record


def close_session(session, error, receipt, out):
    try:
        session.close(error)
    finally:
        auxiliary = session.saves / AUTHORED_AUXILIARY
        record = {AUTHORED_AUXILIARY: {'sha256': io.digest(auxiliary), 'bytes': auxiliary.stat().st_size}} if auxiliary.is_file() else {}
        receipt.setdefault('authored_auxiliary_outputs', {})[session.out.name] = record
        receipt['authored_auxiliary_never_source_or_checkpoint'] = True
        io.write_json(out / 'receipt.json', receipt)


def complete_attempt(args, out, source, old, protected, receipt):
    active = None
    try:
        active = io.Session(args, out / 'producer', source, rc_flags=FLAGS)
        error = None
        try:
            play(active, args.save_name)
        except (OSError, ValueError, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        close_session(active, error, receipt, out)
        saved = active.saves / (args.save_name + '.SAV')
        new = snapshot(saved)
        produced_hash = io.digest(saved)
        producer_saves = save_catalog(active, {source.name: io.digest(source), saved.name: produced_hash})
        receipt.update(producer_save_catalog=producer_saves, produced_output_sha256=produced_hash)
        io.write_json(out / 'receipt.json', receipt)
        io.require(new['difficulty'] == old['difficulty'] and [new[k] for k in ['scene', 'art', 'view', 'held']] == [3520, 3520, 0, -1], 'safe original save state differs')
        io.require(new['owned_cake_items'] == {'0': False, '1': True} and new['progression'] == {1338: 1, 1502: 0, 1503: 0, 1567: 1}, 'real good cake or authored final resets absent')
        path = original_path_check((active.out / 'run.log').read_text())
        producer_receipt = active.out / 'receipt.json'
        active = io.Session(args, out / 'reload', saved, rc_flags=FLAGS)
        error = None
        try:
            obs = note(active, 'fresh output-only Load', active.send(story_route.load_save_prefix() + ';S3520.CIF+24000:shot:0,0'))
            io.require(obs['state'] == [3520, 3520, 0, -1], 'fresh safe reload differs')
            note(active, 'actual inventory reward', active.send(clicked(212, 448)))
            obs = note(active, 'actual good cake1 selection', active.send(clicked(62, 100)))
            io.require(obs['state'] == [3520, 3520, 0, 1], 'fresh selection did not yield real item1')
        except (OSError, ValueError, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        close_session(active, error, receipt, out)
        reload_saves = save_catalog(active, {saved.name: produced_hash})
        io.require(active.source_hash == io.digest(active.copy) == io.digest(saved) == produced_hash, 'output/source-copy/reload hash inequality')
        io.require(all((io.digest(Path(p)) == h for p, h in protected.items())), 'protected input changed')
        accepted = out / saved.name
        io.require(not accepted.exists(), 'optional checkpoint overwrite refused')
        shutil.copy2(saved, accepted)
        io.require(io.digest(accepted) == produced_hash, 'accepted copy differs from original UI output')
        receipt.update(producer_save_catalog=producer_saves, reload_save_catalog=reload_saves, output_and_copy_hashes={'produced_output': produced_hash, 'reload_source': active.source_hash, 'reload_copy': io.digest(active.copy), 'accepted_copy': io.digest(accepted)}, auxiliary_policy='Only original-authored HICONTINUECHEAT.SAV may accompany required source/output after execution; hashes retained, never copied as canonical output or loaded as a source.')
        receipt.update(accepted=True, result='actual original CakeMixing win→bake→physical1→safe UI save/freshheld1 reload', output_save=str(accepted), output_save_sha256=io.digest(accepted), output_state=new, original_path=path, producer_receipt_sha256=io.digest(producer_receipt), reload_receipt_sha256=io.digest(active.out / 'receipt.json'), limits='Pinned optional branch on reviewed b49 only; campaign/ending lineage unchanged; other sources/builds and Mac frontend are unverified.')
        io.write_json(out / 'receipt.json', receipt)
        print(json.dumps(receipt))
        return 0
    finally:
        if active is not None and active.proc.poll() is None:
            try:
                active.close('outer controller refusal')
            except (OSError, ValueError):
                pass


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('native', 'game-exe', 'game-data', 'source-save', 'output'):
        parser.add_argument('--' + name, type=Path, required=True)
    parser.add_argument('--native-sha256', required=True, help='reviewed b49 host SHA-256')
    parser.add_argument('--save-sha256', required=True, help='exact genuine profile source SHA-256')
    parser.add_argument('--profile', choices=sorted(PROFILES), required=True)
    parser.add_argument('--save-name', default='cake32', help='new optional-branch UI name, 1-10 lowercase letters/digits')
    parser.add_argument('--timeout', type=int, default=300, help='per-session wall deadline, 1-300 seconds')
    args = parser.parse_args(argv)
    out = None
    receipt = {'accepted': False, 'client_version': 'cake-live-v1', 'optional_branch_only': True}
    try:
        for name in ('native', 'game_exe', 'game_data', 'source_save'):
            setattr(args, name, getattr(args, name).resolve(strict=True))
        old, helpers = source_guard(args)
        target = args.output.resolve()
        require(not (target == args.game_data or args.game_data in target.parents
                     or target == args.source_save.parent or args.source_save.parent in target.parents),
                'output overlaps supplied data/save')
        target.mkdir(parents=True, exist_ok=False)
        out = target
        protected_paths = (args.source_save, args.native, args.game_exe,
                           args.game_data / 'GAME.EXE', args.game_data / 'Game.ini',
                           args.game_data / 'Ciftree/CIFTREE.DAT', Path(__file__),
                           Path(io.__file__), Path(story_route.__file__), Path(io.check_route.__file__))
        protected = {str(path): io.digest(path) for path in protected_paths}
        receipt.update(profile=args.profile, native_sha256=args.native_sha256,
                       original_sha256=ORIGINAL_SHA256, source_save=str(args.source_save),
                       source_save_sha256=args.save_sha256, source_state=old,
                       controller_sha256=io.digest(Path(__file__)), shared_helpers=helpers,
                       protected_inputs=protected)
        io.write_json(out / 'receipt.json', receipt)
        return complete_attempt(args, out, args.source_save, old, protected, receipt)
    except (OSError, ValueError, subprocess.SubprocessError, KeyboardInterrupt) as failure:
        receipt.update(error=str(failure) or type(failure).__name__)
        if out is not None:
            io.write_json(out / 'receipt.json', receipt)
        print(json.dumps({'accepted': False, 'error': receipt['error'],
                          'evidence': str(out) if out else None}))
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
