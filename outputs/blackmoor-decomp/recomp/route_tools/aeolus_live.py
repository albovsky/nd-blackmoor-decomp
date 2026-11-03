"""One caller-pinned Junior Aeolus attempt using captured pixels and ordinary FIFO input.
Import is read-only. Native launch occurs only in main, after caller path/hash/profile guards.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shutil
import sys
import traceback

P = Path(__file__).resolve().parent
import bul_live as io
import check_route
import story_route
import aeolus_guard as guard
import aeolus_session as transport
import aeolus_pixels
import aeolus_ppm
from types import SimpleNamespace

SAVE_NAME = 'm61'
sha = transport.sha


def load_manifest(args):
    guard.require(args.profile_manifest.stat().st_size <= 65536, 'profile manifest exceeds bounded metadata size')
    guard.require(sha(args.profile_manifest) == args.profile_manifest_sha256, 'profile manifest hash differs')
    manifest = json.loads(args.profile_manifest.read_text())
    validate_manifest(manifest, args)
    return manifest



def load_planner(args):
    return SimpleNamespace(observe=lambda image: aeolus_pixels.observe(image, args.atlas),
                           plan=aeolus_pixels.plan)



def save_payload():
    # Exact prior Senior relative UI save helper, with only its save name changed.
    payload = story_route.menu_to_save_screen('unused', 1000)+';'+story_route.save_tail('unused', 19000, SAVE_NAME)
    return re.sub(r'unused\+(\d+)', r'\1', payload)


def play(session, planner, profile):
    observation, image = session.send(transport.LOAD+';'+(P/'aeolus-navigation.txt').read_text().strip(),
                                      'normal-public-m60-to-authentic-Aeolus-door')
    guard.check_observations(session.observations, profile)
    guard.require(observation['state'] == [3813, 3813, 0, 13] and
                  all(observation['flags'].get(f, 0) == 0 for f in profile['win_flags']),
                  'navigation did not reach the original unfinished3813 door')
    observation, image = session.send((P/'aeolus-start.txt').read_text().strip(), 'unchanged-original-Aeolus-start')
    retries = unready = moves = 0
    for turn in range(200):
        guard.check_observations(session.observations, profile)
        # Existing scene/new-win observations certify readiness and termination.
        # Neither these nor any other flags enter observe()/plan().
        if observation['flags'].get(1959) == 1:
            guard.require(all(observation['flags'].get(f) == 1 for f in (1098, 1099, 1100, 1101))
                          and observation['state'][0] in (3860, 3870, 3871, 3872), 'missing authored allfour win')
            session.event('actual-authored-win', observation=observation)
            observation, image = session.send('1:move:311,355;1001:click:311,355,600;12000:shot:0,0',
                                              'normal-win-exit-to-safe-door')
            guard.require(observation['state'] == [3813, 3813, 0, 13], 'original win exit differed')
            observation, image = session.send(save_payload(), 'original-ui-public-m61-save-after-earned1959')
            guard.check_observations(session.observations, profile, final=True)
            return {'ordinary_pixel_moves': moves, 'original_retries': retries, 'loop_iterations': turn+1}
        if observation['state'][0] == 3848:
            retries += 1
            guard.require(retries <= 20, 'ordinary original retry bound reached')
            session.event('authored-round-failure-or-initial-wind-retry', count=retries, observation=observation)
            observation, image = session.click(502, 223, 16000, 'ordinary-lever-retry-after-authored-failure')
            continue
        if observation['state'][0] != 3940:
            unready += 1
            guard.require(unready <= 8, 'no settled original control scene')
            observation, image = session.shot(16000, 'normal-wind-settle')
            continue
        unready = 0
        pixels = planner.observe(image)
        candidate = planner.plan(pixels, turn)
        session.event('pixels-only-plan', capture=str(image), pixels=pixels, candidate=candidate)
        x, y = candidate['point']
        moves += 1
        observation, image = session.click(x, y, 12000, 'pixels-only-'+candidate['control'])
    raise ValueError('bounded ordinary loop exhausted without original win')


def argument_parser():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('native', 'game-exe', 'game-data', 'source-save', 'profile-manifest', 'atlas', 'output'):
        parser.add_argument('--'+name, type=Path, required=True)
    for name in ('native-sha256', 'game-exe-sha256', 'source-sha256', 'profile-manifest-sha256', 'atlas-sha256'):
        parser.add_argument('--'+name, required=True)
    return parser


def validate_manifest(manifest, args):
    guard.require(isinstance(manifest, dict) and manifest.get('version') == 'aeolus-profile-v1', 'unknown profile manifest')
    for name in ('native_sha256', 'game_exe_sha256', 'source_sha256', 'atlas_sha256'):
        value = getattr(args, name)
        guard.require(isinstance(value, str) and re.fullmatch('[0-9a-f]{64}', value) is not None
                      and manifest.get(name) == value, 'caller/manifest pin differs: '+name)
    guard.require(args.game_exe_sha256 == io.ORIGINAL_SHA256 and args.native_sha256 != io.ORIGINAL_SHA256,
                  'native must be a separate pinned host; original is data only')
    profile = manifest.get('profile', {})
    guard.require(profile.get('source_sha256') == args.source_sha256 and profile.get('state') == [3803,3803,0,13]
                  and profile.get('difficulty') == 0, 'profile must describe the earned Junior mould source/held13')
    _, inherited_one, inherited_zero = check_route.alchemy_win_configuration()
    _, one, zero = check_route.lab_mould_configuration('mould-shape')
    expected = {str(f): int(f in inherited_one|one) for f in inherited_one|inherited_zero|one|zero}
    guard.require(profile.get('flags') == expected, 'profile must preserve all236 prerequisites and corrected24/12 mould')
    guard.require(profile.get('logged_fixed_one') == sorted(one) and profile.get('logged_source_zero') == sorted(zero)
                  and profile.get('win_flags') == [1098,1099,1100,1101,1959,2052], 'profile cannot omit observation/win guards')
    inventory = profile.get('inventory40')
    guard.require(isinstance(inventory, list) and len(inventory) == 40
                  and all(type(v) is int and v in (0,1) for v in inventory)
                  and inventory[10] == 1 and inventory[13] == inventory[15] == 0, 'profile must retain physical10/held13/no15 and40 cells')
    clock = profile.get('clock', {})
    guard.require(set(clock) == {'day','hour','minute'} and all(type(v) is int for v in clock.values())
                  and clock['day'] >= 1 and 0 <= clock['hour'] < 24 and 0 <= clock['minute'] < 60, 'invalid profile clock metadata')
    seed = manifest.get('seed_pins', {})
    roles = {'game.exe','game.ini','ciftree/ciftree.dat','ciftree/s3876.cif'}
    guard.require(isinstance(seed, dict) and {key.casefold() for key in seed} == roles and len(seed) == len(roles),
                  'profile must pin the original/INI/archive/effective mould resource')
    for relative, digest in seed.items():
        path = Path(relative)
        guard.require(not path.is_absolute() and '..' not in path.parts and isinstance(digest, str)
                      and re.fullmatch('[0-9a-f]{64}', digest) is not None, 'invalid relative seed pin')
        if relative.casefold() == 'game.exe':
            guard.require(digest == args.game_exe_sha256, 'seed original image pin differs')


def validate_output(output, source, seed, original):
    guard.require(not output.exists() and output != seed and seed not in output.parents
                  and source.parent not in output.parents and original.parent not in output.parents,
                  'output must be new and outside original/source/data directories')
    # resolve() preserves case aliases on case-insensitive volumes. Compare the
    # existing ancestors by filesystem identity before creating any directory.
    protected = (seed, source.parent, original.parent)
    for ancestor in output.parents:
        if ancestor.exists():
            guard.require(not any(ancestor.samefile(path) for path in protected),
                          'output must be outside original/source/data directories')


def preflight(args, output, manifest):
    profile = manifest['profile']
    for path, digest in ((args.native,args.native_sha256), (args.game_exe,args.game_exe_sha256),
                         (args.source_save,args.source_sha256), (args.atlas,args.atlas_sha256)):
        guard.require(path.is_file() and sha(path) == digest, 'caller file hash differs: '+str(path))
    guard.require(args.source_save.name.lower() != SAVE_NAME+'.sav', 'new save name must differ from source')
    actual = guard.read_profile(args.source_save, profile)
    guard.check_profile(actual, profile, won=False)
    guard.require(actual['clock'] == profile['clock'], 'profile source clock fingerprint differs')
    seed = args.game_data
    guard.require(not (seed/'Documents5').exists() and not any(p.is_symlink() for p in seed.rglob('*')),
                  'immutable seed must contain no saves or symlinks')
    validate_output(output, args.source_save, seed, args.game_exe)
    protected = {str(path): digest for path,digest in ((args.native,args.native_sha256),
                  (args.game_exe,args.game_exe_sha256),(args.source_save,args.source_sha256),
                  (args.atlas,args.atlas_sha256),(args.profile_manifest,args.profile_manifest_sha256))}
    for relative, digest in manifest['seed_pins'].items():
        path = seed/relative
        guard.require(sha(path) == digest, 'original seed pin differs: '+relative)
        protected[str(path)] = digest
    for path in (Path(__file__), Path(guard.__file__), Path(transport.__file__), Path(aeolus_pixels.__file__),
                 Path(aeolus_ppm.__file__), Path(io.__file__), Path(check_route.__file__), Path(story_route.__file__),
                 P/'aeolus-navigation.txt', P/'aeolus-start.txt', P/'aeolus-reload.txt'):
        protected[str(path)] = sha(path)
    return protected



def main(argv=None):
    args = argument_parser().parse_args(argv)
    active = None
    output_created = False
    receipt = {'accepted': False, 'acceptance_owner': 'combined original-UI save and independent reload',
               'source_sha256': args.source_sha256, 'native_sha256': args.native_sha256, 'scope': 'one actual ordinary pixels-only attempt; no all-board guarantee'}
    output = args.output.resolve()
    try:
        for name in ('native','game_exe','game_data','source_save','profile_manifest','atlas'):
            setattr(args, name, getattr(args,name).resolve(strict=True))
        manifest = load_manifest(args)
        profile = manifest['profile']
        protected = preflight(args, output, manifest)
        output.mkdir(parents=True)
        output_created = True
        (output/'receipt.json').write_text(json.dumps(receipt, indent=2)+'\n')
        producer = active = transport.Session(output/'producer', args.source_save, args.source_sha256, guard.scope(profile), runtime=args)
        # Existing session spelling is retained internally; expose no game reads.
        producer.observations = producer.obs
        result = play(producer, load_planner(args), profile)
        producer.close('earned-public-Aeolus-new1959-ui-m61')
        active = None
        guard.check_protocol_receipt(producer.receipt)
        log = (producer.out/'run.log').read_text()
        guard.check_requested_stop(log)
        guard.check_observations(producer.obs, profile, final=True)
        opened = {int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF', log)}
        guard.require({3810,3811,3812,3813,3848,3940,3860,3861} <= opened and bool(opened & {3870,3871,3872}),
                      'missing original staging/control/win/return resources')
        saved = producer.saves/(SAVE_NAME+'.SAV')
        guard.check_profile(guard.read_profile(saved, profile), profile, won=True)
        guard.require({p.name for p in producer.saves.glob('*.SAV')} <= {args.source_save.name,saved.name,'HICONTINUECHEAT.SAV'},
                      'producer has an unexpected save')
        saved_hash = sha(saved)
        reload = active = transport.Session(output/'reload', saved, saved_hash, guard.scope(profile), runtime=args)
        reload.send(transport.LOAD+';'+(P/'aeolus-reload.txt').read_text().strip(), 'fresh-new-m61-only-reload')
        reload.close('independent-fresh-new-m61-only-reload')
        active = None
        guard.check_protocol_receipt(reload.receipt)
        guard.check_requested_stop((reload.out/'run.log').read_text())
        guard.check_observations(reload.obs, profile, final=True)
        guard.check_profile(guard.read_profile(reload.saves/saved.name, profile), profile, won=True)
        guard.require({p.name for p in reload.saves.glob('*.SAV')} == {saved.name}, 'reload has extra saves')
        guard.require(all(sha(Path(path)) == digest for path,digest in protected.items()), 'protected inputs changed')
        target = output/saved.name
        guard.require(not target.exists(), 'refuse checkpoint overwrite')
        shutil.copy2(saved, target)
        receipt.update(accepted=True, result=result, output_save=str(target), output_sha256=sha(target),
                       producer_receipt_sha256=sha(producer.out/'receipt.json'), reload_receipt_sha256=sha(reload.out/'receipt.json'),
                       protected_inputs=protected)
        (output/'receipt.json').write_text(json.dumps(receipt, indent=2)+'\n')
        print(json.dumps({'accepted':True,'receipt':str(output/'receipt.json'),'output_sha256':receipt['output_sha256']}), flush=True)
        return 0
    except (Exception, KeyboardInterrupt) as failure:
        receipt.update(error=repr(failure), traceback=traceback.format_exc())
        if active is not None:
            try: active.close('incomplete-or-error', repr(failure))
            except Exception as cleanup: receipt['cleanup_error'] = repr(cleanup)
        if output_created: (output/'receipt.json').write_text(json.dumps(receipt, indent=2)+'\n')
        print('Aeolus attempt refused: '+repr(failure), file=sys.stderr)
        return 4


if __name__ == '__main__':
    raise SystemExit(main())
