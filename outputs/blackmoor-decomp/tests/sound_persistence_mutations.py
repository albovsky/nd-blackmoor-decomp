#!/usr/bin/env python3
"""RT-11 mutation acceptance. Private builds; immutable originals; no device.

Run after the normal libraries/app are built. Every mutant must compile and
fail a behavioral scenario/oracle assertion. Build failures are not kills.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
WORK = ROOT / 'work/analysis/slices/RT-11.mutations'
PYTHON = ROOT / 'work/tools/oracle-python/bin/python'
FLAGS = ['-arch', 'arm64', '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g']


def checked(cmd, log, env=None):
    p = subprocess.run(cmd, capture_output=True, text=True, env=env)
    log.write_text(p.stdout + p.stderr)
    if p.returncode:
        raise RuntimeError(f'build/baseline failure {p.returncode}: {log}')


def driver(out, live, session):
    checked(['xcrun', 'clang', '-arch', 'arm64', '-std=gnu17', '-Wall', '-Wextra', '-Werror',
             '-O1', '-g', '-I' + str(PROJECT / 'src'),
             str(PROJECT / 'tests/sound_persistence_test.c'), str(live), str(session),
             '-L' + str(PROJECT / 'build'), '-lmacos_audio', '-lhis_audio',
             '-Wl,-rpath,' + str(PROJECT / 'build'), '-o', str(out)], out.with_suffix('.build.log'))


def run():
    import test_live_audio as fixtures
    WORK.mkdir(parents=True, exist_ok=True)
    tree = WORK / 'game'
    if not tree.exists():
        fixtures.build_fixture_tree(tree)
    baseline = WORK / 'baseline'
    driver(baseline, PROJECT / 'build/libliveaudio.dylib', PROJECT / 'build/libsessionexit.dylib')
    checked([str(baseline), str(tree)], WORK / 'baseline.log')
    results = []
    provider = (PROJECT / 'src/live_audio.c').read_text()
    planner = (PROJECT / 'src/session_exit.c').read_text()
    mutations = [
        ('always_unload', 'live_audio.c',
         '    for (size_t i = 0; i < count; ++i) {\n        const uint16_t channel = channels[i];',
         '    uint16_t all[32];\n    for (uint16_t i = 0; i < 32; ++i) all[i] = i;\n'
         '    channels = all; count = 32;\n'
         '    for (size_t i = 0; i < count; ++i) {\n        const uint16_t channel = channels[i];'),
        ('never_unload', 'live_audio.c',
         'if (release_channel(audio, channel) != MAC_AUDIO_OK) result = LIVE_AUDIO_ERR_HOST;',
         'if (0) result = LIVE_AUDIO_ERR_HOST;'),
        ('abort_on_stop_failure', 'live_audio.c',
         'if (release_channel(audio, channel) != MAC_AUDIO_OK) result = LIVE_AUDIO_ERR_HOST;',
         'if (release_channel(audio, channel) != MAC_AUDIO_OK) return LIVE_AUDIO_ERR_HOST;'),
        ('wrong_channel_set', 'live_audio.c',
         'const uint16_t channel = channels[i];', 'const uint16_t channel = (uint16_t)i;'),
        ('reset_continuations', 'session_exit.c',
         'if (exit_state->g.game_state == SESSION_EXIT_STATE_INTRO) {', 'if (1) {'),
        ('missing_menu_channel', 'session_exit.c',
         'plan->channels[plan->count++] = menu_sound_channel; /* 0x4fc05d */',
         '(void)menu_sound_channel;'),
        ('missing_channel13', 'session_exit.c', 'channel < 14u;', 'channel < 13u;'),
    ]
    for name, file, old, new in mutations:
        directory = WORK / name
        directory.mkdir(exist_ok=True)
        source = provider if file == 'live_audio.c' else planner
        assert source.count(old) == 1, (name, source.count(old))
        mutant = directory / file
        mutant.write_text(source.replace(old, new))
        live = PROJECT / 'build/libliveaudio.dylib'
        session = PROJECT / 'build/libsessionexit.dylib'
        if file == 'live_audio.c':
            live = directory / 'libliveaudio.dylib'
            checked(['xcrun', 'clang', *FLAGS, '-I' + str(PROJECT / 'src'), '-fPIC', '-dynamiclib',
                     str(mutant), str(PROJECT / 'src/sound_control.c'),
                     '-L' + str(PROJECT / 'build'), '-lmacos_audio', '-lhis_audio',
                     '-Wl,-rpath,' + str(PROJECT / 'build'), '-o', str(live)], directory / 'build.log')
        else:
            src = directory / 'src'
            shutil.copytree(PROJECT / 'src', src, dirs_exist_ok=True)
            shutil.copy2(mutant, src / file)
            session = directory / 'libsessionexit.dylib'
            checked([str(PROJECT / 'scripts/build_session_exit.sh')], directory / 'build.log',
                    {**os.environ, 'SESSION_EXIT_SRC': str(src), 'SESSION_EXIT_OUTPUT': str(session)})
        binary = directory / 'scenario'
        driver(binary, live, session)
        p = subprocess.run([str(binary), str(tree)], capture_output=True, text=True)
        (directory / 'scenario.log').write_text(p.stdout + p.stderr)
        assert p.returncode != 0 and 'Assertion failed' in p.stderr, f'survived/invalid: {name}'
        entry = {'name': name, 'compiled': True, 'scenario_killed': True, 'returncode': p.returncode}
        if file == 'session_exit.c':
            p = subprocess.run([str(PYTHON), str(PROJECT / 'tests/sound_persistence_original_oracle.py'),
                                '--library', str(session), '--report', str(directory / 'oracle.json')],
                               capture_output=True, text=True)
            (directory / 'oracle.log').write_text(p.stdout + p.stderr)
            assert p.returncode != 0 and 'AssertionError' in p.stderr, f'oracle survived: {name}'
            entry['oracle_killed'] = True
        results.append(entry)
    # Frozen copies of production app sources verify the actual transition
    # glue as well as the provider kernels. No source in this checkout changes.
    def app_mutant(name, edit, test_filter, expect):
        directory = WORK / name
        shutil.rmtree(directory, ignore_errors=True)
        shutil.copytree(PROJECT / 'src', directory / 'src', dirs_exist_ok=True)
        shutil.copytree(PROJECT / 'scripts', directory / 'scripts', dirs_exist_ok=True)
        app = directory / 'src/blackmoor_app.mm'
        app.write_text(edit(app.read_text()))
        checked([str(directory / 'scripts/build_native_app.sh'), '--test-hooks'], directory / 'build.log')
        executable = directory / 'Blackmoor Reconstruction Test.app/Contents/MacOS/BlackmoorNative'
        p = subprocess.run([str(PYTHON), '-m', 'unittest', 'discover', '-s', str(PROJECT / 'tests'),
                            '-p', 'test_native_app.py', '-k', test_filter], capture_output=True,
                           text=True, env={**os.environ, 'RT4_NATIVE_EXECUTABLE': str(executable)})
        (directory / 'scenario.log').write_text(p.stdout + p.stderr)
        assert p.returncode != 0 and 'AssertionError' in p.stderr and expect in p.stderr, (
            'app mutant survived or failed for the wrong reason: ' + name)
        results.append({'name': name, 'compiled': True, 'scenario_killed': True,
                        'returncode': p.returncode})

    def replace_once(text, old, new):
        assert text.count(old) == 1, old
        return text.replace(old, new)

    marker = '    record_scene_audio(app, "after-load", source, transition.target_scene);'
    app_mutant('app_blanket_unload',
               lambda t: replace_once(t, marker, '    live_audio_unload_all(app->live_audio);\n' + marker),
               'continuation_keeps', 'loaded=1')
    app_mutant('app_skip_fresh_reset',
               lambda t: replace_once(t, 'live_audio_unload_channels(app->live_audio, plan.channels, plan.count)',
                                      'LIVE_AUDIO_OK'),
               'fresh_entry_resets', 'channel=4 loaded=1')
    app_mutant('app_reset_every_transition',
               lambda t: replace_once(t, marker,
                   '    { const uint16_t rt11[15] = {27,0,1,2,3,4,5,6,7,8,9,10,11,12,13};\n'
                   '      (void)live_audio_unload_channels(app->live_audio, rt11, 15); }\n' + marker),
               'continuation_keeps', 'channel=9 loaded=1')
    app_mutant('app_fade_on_reset',
               lambda t: replace_once(t, 'record_scene_audio(app, "after-intro-reset", app->current_scene_id, app->current_scene_id);',
                                      'if (app->live_audio) (void)live_audio_set_category_scalar(app->live_audio, 2, 0.5f);\n    record_scene_audio(app, "after-intro-reset", app->current_scene_id, app->current_scene_id);'),
               'fresh_entry_resets', 'gain=0.640000')
    report = {'mutants': len(results), 'killed': len(results), 'results': results}
    (WORK.parent / 'RT-11.mutations.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'mutants': len(results), 'killed': len(results)}))


if __name__ == '__main__':
    run()
