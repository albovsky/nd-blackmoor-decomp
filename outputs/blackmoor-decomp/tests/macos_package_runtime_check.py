#!/usr/bin/env python3
"""Private, quiet package acceptance. Writes evidence only to the supplied fresh directory.

No accounts, device audio or foreground activation. CFFIXED_USER_HOME gives just
these child processes isolated Foundation Application Support paths. sandbox-exec
denies every Homebrew file read, rather than renaming a shared system directory.
The optional save is a game-created pre-ending checkpoint, loaded and saved by UI.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import plistlib
import shutil
import subprocess
import sys
import time
import wave


def sha(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def listing(root):
    entries = []
    for path in sorted(root.rglob('*')):
        st = path.lstat()
        entries.append([str(path.relative_to(root)), st.st_mode, st.st_size,
                        st.st_mtime_ns, os.readlink(path) if path.is_symlink()
                        else sha(path) if path.is_file() else None])
    return hashlib.sha256(json.dumps(entries, separators=(',', ':')).encode()).hexdigest()


def command(args, check=True, **kwargs):
    result = subprocess.run(list(map(str, args)), text=True, capture_output=True, **kwargs)
    if check and result.returncode:
        raise RuntimeError(f'{args[0]} failed ({result.returncode}): {result.stdout}{result.stderr}')
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dmg', type=Path, required=True)
    parser.add_argument('--seed', type=Path, required=True)
    parser.add_argument('--probe', type=Path, required=True)
    parser.add_argument('--save', type=Path)
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--expected-source-commit', required=True)
    args = parser.parse_args()
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    before = listing(args.seed)
    proof = {'seed_listing_before_sha256': before, 'dmg_sha256': sha(args.dmg)}
    try:
        mounted = command(['/usr/bin/hdiutil', 'attach', '-readonly', '-nobrowse', '-plist', args.dmg])
        volume = next(Path(item['mount-point']) for item in plistlib.loads(mounted.stdout.encode())['system-entities']
                      if 'mount-point' in item)
        app = out / 'Blackmoor Recompiled.app'
        try:
            command(['/usr/bin/ditto', '--noextattr', '--norsrc', volume / app.name, app])
        finally:
            command(['/usr/bin/hdiutil', 'detach', volume])
        manifest_path = args.dmg.parent / 'package-manifest.json'
        manifest = json.loads(manifest_path.read_text())
        metadata = plistlib.loads((app / 'Contents/Info.plist').read_bytes())
        if manifest['dmg_sha256'] != proof['dmg_sha256'] or manifest['source_commit'] != args.expected_source_commit \
                or metadata.get('BlackmoorSourceCommit') != args.expected_source_commit:
            raise AssertionError('DMG, manifest and frozen source commit do not agree')
        executable = app / 'Contents/MacOS/BlackmoorRecompiled'
        if sha(executable) != manifest['app_files_sha256']['Contents/MacOS/BlackmoorRecompiled']:
            raise AssertionError('copied executable differs from the package manifest')
        proof['source_commit'] = args.expected_source_commit
        proof['native_sha256'] = sha(executable)
        proof['package_manifest_sha256'] = sha(manifest_path)
        print('SOURCE_COMMIT', proof['source_commit'])
        command(['/usr/bin/xattr', '-w', 'com.apple.quarantine', '0083;00000000;BlackmoorPackaging;', app])
        assessed = command(['/usr/sbin/spctl', '--assess', '--type', 'execute', '--verbose=2', app], check=False)
        (out / 'spctl.txt').write_text(assessed.stdout + assessed.stderr)
        proof['quarantined_spctl_returncode'] = assessed.returncode
        proof['quarantined_spctl_output'] = assessed.stdout + assessed.stderr
        proof['trusted_quarantined_launch_eligible'] = assessed.returncode == 0
        command(['/usr/bin/codesign', '--verify', '--deep', '--strict', app])
        if assessed.returncode:
            # An ad-hoc build is expected to be blocked by Gatekeeper. Preserve
            # that result and its quarantined copy. Exercise the local build in
            # a separate copy without imported extended attributes; this never
            # counts as a trusted quarantined launch or disables Gatekeeper.
            local = out / 'local-build'
            local.mkdir()
            local_app = local / app.name
            command(['/usr/bin/ditto', '--noextattr', '--norsrc', app, local_app])
            app = local_app
            proof['local_unquarantined_runtime_copy'] = str(app)
        binaries = [app / 'Contents/MacOS/BlackmoorRecompiled'] + sorted((app / 'Contents/Frameworks').glob('*.dylib'))
        loads = ''.join(command(['/usr/bin/otool', '-L', binary]).stdout for binary in binaries)
        (out / 'otool.txt').write_text(loads)
        if '/opt/homebrew' in loads or '/usr/local' in loads:
            raise AssertionError('external Homebrew load command')
        for line in loads.splitlines():
            if line.startswith('\t') and not line.lstrip().startswith(('/usr/lib/', '/System/', '@rpath/', '@loader_path/', '@executable_path/')):
                raise AssertionError('external dependency: ' + line)
        print(loads, end='')
        validated = command([args.probe, args.seed])
        proof['valid_folder'] = validated.stdout.strip()
        print(validated.stdout, end='')
        for mode in ('empty', 'wrong', 'missing', 'wrong-version'):
            folder = out / mode
            folder.mkdir()
            if mode == 'wrong':
                (folder / 'readme.txt').write_text('This is another folder.\n')
            if mode in ('missing', 'wrong-version'):
                (folder / 'GAME.EXE').write_text('An unsupported test executable.\n')
            if mode == 'wrong-version':
                (folder / 'Game.ini').write_text('fixture\n')
                (folder / 'Ciftree').mkdir()
                (folder / 'Ciftree/CIFTREE.DAT').write_text('fixture\n')
                (folder / 'CDSound').mkdir()
                (folder / 'CDVideo').mkdir()
            result = command([args.probe, folder], check=False)
            if result.returncode != 1:
                raise AssertionError('bad folder accepted: ' + mode)
            proof[mode] = result.stdout.strip()
            print(result.stdout, end='')

        isolated_home = out / 'home'
        isolated_home.mkdir()
        empty_libraries = out / 'empty-library-path'
        empty_libraries.mkdir()
        environment = dict(os.environ)
        for key in ('BLACKMOOR_GAME_DIR', 'GAME_EXE', 'INPUT', 'RC_CONTROL_FIFO', 'RC_OUT'):
            environment.pop(key, None)
        environment.update(CFFIXED_USER_HOME=str(isolated_home), DYLD_PRINT_LIBRARIES='1',
                           DYLD_LIBRARY_PATH=str(empty_libraries), DYLD_FALLBACK_LIBRARY_PATH=str(empty_libraries))
        policy = '(version 1) (allow default) (deny file-read* (subpath "/opt/homebrew") (subpath "/usr/local"))'

        def launch(name, input_path=None, timeout_ms=15000):
            run_log = out / (name + '.log')
            argv = ['/usr/bin/sandbox-exec', '-p', policy, str(binaries[0]), '--background', '--mute',
                    '--stop-after-ms', str(timeout_ms), '--log', str(run_log),
                    '--capture-audio', str(out / (name + '.wav'))]
            if input_path:
                argv += ['--input-file', str(input_path)]
            with (out / (name + '-stdout.txt')).open('w') as stream:
                process = subprocess.Popen(argv, env=environment, stdout=stream, stderr=subprocess.STDOUT)
                time.sleep(3)
                maps = command(['/usr/bin/vmmap', str(process.pid)], check=False)
                (out / (name + '-vmmap.txt')).write_text(maps.stdout + maps.stderr)
                try:
                    result = process.wait(timeout=timeout_ms / 1000 + 30)
                except subprocess.TimeoutExpired:
                    process.terminate()
                    try:
                        process.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        process.kill()
                        process.wait()
                    raise
            log = run_log.read_text() if run_log.exists() else ''
            if result or 'BACKGROUND result=failed' in log:
                raise AssertionError(f'{name} runtime failed: {result}; see {out}')
            data_line = next(line for line in log.splitlines() if line.startswith('GAME_DATA mode='))
            actual_save_root = Path(data_line.split(' saves=', 1)[1]).resolve()
            if actual_save_root != (isolated_home / 'Library/Application Support/Blackmoor Recompiled').resolve():
                raise AssertionError('Foundation save path was not isolated')
            if maps.returncode or any(path in maps.stdout for path in ('/opt/homebrew/', '/usr/local/')):
                raise AssertionError('could not prove loaded library independence with vmmap')
            for library in ('libavformat.', 'libavcodec.', 'libavutil.', 'libswscale.', 'libswresample.'):
                if 'Contents/Frameworks/' + library not in maps.stdout:
                    raise AssertionError('bundled library not observed: ' + library)
            if not all(x in log for x in ('active=0', 'key=0', 'visible=0', 'activations=0')):
                raise AssertionError('background contract missing')
            with wave.open(str(out / (name + '.wav')), 'rb') as audio:
                frames = audio.getnframes()
            proof[name] = {'returncode': result, 'pcm_frames': frames, 'log_sha256': sha(run_log),
                           'vmmap_sha256': sha(out / (name + '-vmmap.txt'))}
            return log

        log = launch('main-menu')
        if 'MAIN.CIF' not in log:
            raise AssertionError('main menu did not open')
        print(next(line for line in log.splitlines() if 'MAIN.CIF' in line))
        proof['homebrew_file_access_denied'] = policy
        if args.save:
            saves = isolated_home / 'Library/Application Support/Blackmoor Recompiled/Documents5/The Curse of Blackmoor Manor'
            saves.mkdir(parents=True, exist_ok=True)
            shutil.copy2(args.save, saves / 'm77.SAV')
            sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'recomp/route_tools'))
            from story_route import load_save_prefix, menu_to_save_screen, save_tail
            payload = ';'.join([load_save_prefix(), menu_to_save_screen('S3844.CIF', 3000),
                                save_tail('S3844.CIF', 15000, 'pkgcheck')])
            input_path = out / 'save-input.txt'
            input_path.write_text(payload + '\n')
            log = launch('ui-save', input_path, 65000)
            saved = saves / 'pkgcheck.SAV'
            if not saved.is_file() or 'complete=1' not in log:
                raise AssertionError('ordinary UI save did not complete in Application Support')
            proof['created_save'] = str(saved)
            proof['created_save_sha256'] = sha(saved)
            print('SAVE_IN_APPLICATION_SUPPORT', saved)
    finally:
        proof['seed_listing_after_sha256'] = listing(args.seed)
        proof['seed_unchanged'] = proof['seed_listing_before_sha256'] == proof['seed_listing_after_sha256']
        (out / 'proof.json').write_text(json.dumps(proof, indent=2) + '\n')
        print('SEED_LISTING_BEFORE', proof['seed_listing_before_sha256'])
        print('SEED_LISTING_AFTER ', proof['seed_listing_after_sha256'])
    if not proof['seed_unchanged']:
        raise AssertionError('original folder changed')
    print('QUIET_RUNTIME_PROOF_PASS', out)


if __name__ == '__main__':
    main()
