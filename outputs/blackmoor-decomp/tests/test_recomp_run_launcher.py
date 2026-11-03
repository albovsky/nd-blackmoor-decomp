#!/usr/bin/env python3
"""Finite shell command fakes: no real build/install/app/OS dispatch/device."""
import argparse
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile


def check(value, message):
    if not value:
        raise ValueError(message)


FAKE_TOOL = r"""import json, os
from pathlib import Path
import shutil, sys
name, args = sys.argv[1], sys.argv[2:]
log = Path(os.environ['FAKE_LOG'])
rows = [json.loads(line) for line in log.read_text().splitlines()] if log.exists() else []
row = {'tool': name, 'args': args, 'pid': os.getpid(), 'PATH': os.environ.get('PATH', '')}
if name == 'app':
    row['executable'], row['args'] = args[0], args[1:]
rows.append(row)
log.write_text(''.join(json.dumps(item) + '\n' for item in rows))
if name == 'python':
    sys.stdin.read()
elif name == 'ditto':
    shutil.copytree(args[-2], args[-1])
elif name == 'pgrep':
    if os.environ.get('FAKE_QUERY_ERROR') == '1':
        raise SystemExit(2)
    raise SystemExit(0 if os.environ.get('FAKE_USER_GAME') == '1' else 1)
elif name == 'ps':
    app = next(item for item in rows if item['tool'] == 'app')
    if args != ['-p', str(app['pid']), '-o', 'command=']:
        raise SystemExit(1)
    print(app['executable'] + ' ' + ' '.join(app['args']))
"""


def scenario(launcher, arguments, *, running=False, python=True, query_error=False):
    with tempfile.TemporaryDirectory(prefix='blackmoor-launcher-fakes-') as temporary:
        workspace = Path(temporary) / 'workspace with spaces'
        (workspace / 'script').mkdir(parents=True)
        tools = workspace / 'fakes'
        tools.mkdir()
        implementation = tools / 'tool.py'
        implementation.write_text(FAKE_TOOL)
        def command(path, name):
            path.parent.mkdir(parents=True, exist_ok=True)
            own_path = ' "$0"' if name == 'app' else ''
            path.write_text('#!/bin/bash\nexec ' + shlex.quote(sys.executable) + ' ' +
                            shlex.quote(str(implementation)) + ' ' + shlex.quote(name) + own_path + ' "$@"\n')
            path.chmod(0o755)
        text = launcher.read_text()
        for name in ('open', 'ditto', 'codesign', 'lldb', 'log', 'pgrep', 'pkill'):
            command(tools / name, name)
            text = text.replace('/usr/bin/' + name, shlex.quote(str(tools / name)))
        command(tools / 'ps', 'ps')
        text = text.replace('/bin/ps', shlex.quote(str(tools / 'ps')))
        script = workspace / 'script/build_and_run.sh'
        script.write_text(text)
        project = workspace / 'outputs/blackmoor-decomp'
        command(project / 'recomp/build_macos.sh', 'build')
        command(project / 'scripts/build_native_app.sh', 'preview-build')
        command(project / 'Blackmoor Recompiled.app/Contents/MacOS/BlackmoorRecompiled', 'app')
        command(project / 'Blackmoor Reconstruction.app/Contents/MacOS/BlackmoorNative', 'preview-app')
        (project / 'recomp/requirements-build.txt').write_text('pefile==2024.8.26\ncapstone==5.0.9\n')
        venv = workspace / 'work/tools/recomp-python/bin'
        if python:
            command(venv / 'python3', 'python')
        out = workspace / 'calls.jsonl'
        env = dict(os.environ, FAKE_LOG=str(out), FAKE_USER_GAME=str(int(running)), TMPDIR=temporary,
                   FAKE_QUERY_ERROR=str(int(query_error)),
                   PYTHONDONTWRITEBYTECODE='1')
        env.pop('BLACKMOOR_BUNDLE_PATH', None)
        result = subprocess.run(['/bin/bash', str(script), *arguments], cwd=workspace, env=env,
                                capture_output=True, text=True, timeout=10)
        calls = [json.loads(line) for line in out.read_text().splitlines()] if out.exists() else []
        if result.returncode == 0:
            check(sum(row['tool'] == 'build' for row in calls) == 1, 'wrong/missing recompiled builder')
            build = next(row for row in calls if row['tool'] == 'build')
            check(Path(build['PATH'].split(os.pathsep)[0]).resolve() == venv.resolve(), 'project-local Python not selected')
        check(not any(row['tool'] in ('pkill', 'open') for row in calls), 'termination or LaunchServices attempted')
        return result, calls


def app_and_pid(calls, expected):
    app = next(row for row in calls if row['tool'] == 'app')
    check(app['executable'].endswith('/Blackmoor Recompiled.app/Contents/MacOS/BlackmoorRecompiled')
          and app['args'] == expected, 'direct target/mute/quoted arguments differ')
    return app


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--launcher', type=Path, default=Path(__file__).resolve().parents[3] / 'script/build_and_run.sh')
    launcher = parser.parse_args().launcher.resolve(strict=True)
    result, calls = scenario(launcher, [])
    check(result.returncode == 0, result.stderr)
    app_and_pid(calls, ['--mute'])
    result, calls = scenario(launcher, ['--verify', '--background', '--game-dir', 'data path with spaces'])
    check(result.returncode == 0, result.stderr)
    app = app_and_pid(calls, ['--mute', '--background', '--game-dir', 'data path with spaces'])
    ps = next(row['args'] for row in calls if row['tool'] == 'ps')
    check(ps == ['-p', str(app['pid']), '-o', 'command='], 'verification did not check its own child PID/path')
    result, calls = scenario(launcher, ['--debug', '--background'])
    check(result.returncode == 0, result.stderr)
    debug = next(row['args'] for row in calls if row['tool'] == 'lldb')
    check(debug[0] == '--' and debug[1].endswith('/Contents/MacOS/BlackmoorRecompiled')
          and debug[2:] == ['--mute', '--background'], 'debug target/quiet args differ')
    for mode in ('--logs', '--telemetry'):
        result, calls = scenario(launcher, [mode, '--background'])
        check(result.returncode == 0, result.stderr)
        app_and_pid(calls, ['--mute', '--background'])
        check(any(row['tool'] == 'ps' for row in calls)
              and next(row['args'] for row in calls if row['tool'] == 'log')[-1] == 'process == "BlackmoorRecompiled"',
              'log mode lacks own process check or correct process filter')
    result, calls = scenario(launcher, ['--build-only'])
    check(result.returncode == 0 and [row['tool'] for row in calls] == ['pgrep', 'python', 'build'],
          'build-only reached staging or launch')
    result, calls = scenario(launcher, [], running=True)
    check(result.returncode == 1 and [row['tool'] for row in calls] == ['pgrep']
          and 'already running' in result.stderr, 'existing game was not preserved before build')
    result, calls = scenario(launcher, [], query_error=True)
    check(result.returncode == 1 and [row['tool'] for row in calls] == ['pgrep']
          and 'Cannot check' in result.stderr, 'failed process query reached build or launch')
    result, calls = scenario(launcher, [], python=False)
    check(result.returncode == 1 and [row['tool'] for row in calls] == ['pgrep']
          and 'setup_recomp_python.sh' in result.stderr, 'missing local Python did not refuse before build')
    result, calls = scenario(launcher, ['--unknown-mode'])
    check(result.returncode == 2 and not calls, 'invalid mode reached a build or OS command')
    print('PASS10 finite launcher shell-fake cases; no real build/install/app/device execution')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError, StopIteration) as error:
        print('FAIL launcher fakes: ' + str(error), file=sys.stderr)
        raise SystemExit(1)
