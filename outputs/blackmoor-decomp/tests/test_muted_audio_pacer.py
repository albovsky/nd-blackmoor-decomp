#!/usr/bin/env python3
"""Compile/run only the finite host-clock fixture; no app, game or devices."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import shlex
import unittest
import subprocess
import tempfile


def main():
    tests = Path(__file__).resolve().parent
    repo = tests.parents[2]
    compiler = shlex.split(os.environ.get('CXX', 'c++'))
    if not compiler or not shutil.which(compiler[0]):
        print('C++ compiler is required')
        return 2
    scratch = Path(os.environ.get('BLACKMOOR_ORIGINAL_WORK', str(repo / 'work'))) / 'muted-clock-tests'
    scratch.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='case-', dir=str(scratch)))
    fixture = tests / 'muted_audio_pacer_fixture.cpp'
    header = tests.parent / 'recomp/muted_audio_pacer.h'
    executable = work / 'muted_audio_pacer_fixture'
    commands = (compiler + ['-std=c++17', '-O2', '-Wall', '-Wextra', '-Werror',
                 str(fixture), '-o', str(executable)], [str(executable)])
    receipt = {'scope': 'finite synthetic host times only; no workers/game/devices',
               'sources_sha256': {str(p.relative_to(repo)): hashlib.sha256(p.read_bytes()).hexdigest()
                                  for p in (fixture, header)}, 'commands': []}
    ok = True
    log = []
    try:
        for index, command in enumerate(commands):
            result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                    text=True, timeout=30 if index == 0 else 2)
            log.append('$ ' + ' '.join(command) + '\n' + result.stdout)
            receipt['commands'].append({'argv': command, 'exit_code': result.returncode})
            if result.returncode:
                ok = False
                break
    except (OSError, subprocess.SubprocessError) as error:
        ok = False
        log.append(str(error) + '\n')
    receipt['passed'] = ok
    if executable.is_file():
        receipt['fixture_sha256'] = hashlib.sha256(executable.read_bytes()).hexdigest()
    (work / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
    (work / 'run.log').write_text(''.join(log))
    print('PASS: finite synthetic muted-pacer checks' if ok else 'FAIL: see ' + str(work / 'run.log'))
    return 0 if ok else 1


class MutedAudioPacerTests(unittest.TestCase):
    def test_fixed_phase_and_bounded_overruns(self):
        self.assertEqual(main(), 0)


if __name__ == '__main__':
    unittest.main()
