"""Check generated-native sqrt; requires owner-local GAME_EXE and built objects.

RECOMP_BUILD selects an existing build. This test never relifts or rebuilds it,
executes original x86 code, or enters the game. Scope: finite nonnegative inputs,
empty x87 stack and CW=0x27f; no general CRT or exceptional-value parity claim.
"""
import hashlib
import json
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import sys
import tempfile
import unittest


PROJECT = Path(__file__).resolve().parents[1]
WORK = Path(os.environ.get('BLACKMOOR_ORIGINAL_WORK', PROJECT.parents[1] / 'work'))
ORIGINAL = Path(os.environ.get('GAME_EXE', WORK / 'original/GAME.EXE'))
ORIGINAL_SHA256 = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
MODULES = ('rc_generated', 'rc_core', 'rc_threads', 'rc_win32', 'rc_ddraw',
           'rc_dsound', 'rc_bink', 'rc_main', 'rc_unlifted')


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class RecompSqrtTests(unittest.TestCase):
    def test_generated_sqrt_returns_finite_nonnegative_roots(self):
        if not ORIGINAL.is_file():
            self.skipTest('Owner-local GAME.EXE unavailable; set GAME_EXE')
        self.assertEqual(sha(ORIGINAL), ORIGINAL_SHA256, 'Owner-local GAME.EXE identity mismatch')
        configured = os.environ.get('RECOMP_BUILD')
        defaults = [PROJECT / 'build/recomp-macos', PROJECT / 'build/recomp-linux', WORK / 'build/recomp']
        build = Path(configured) if configured else next((p for p in defaults if p.is_dir()), defaults[0])
        objects = sorted(build.glob('rc_lifted_*.o'))
        if not objects or not all((build / (name + '.o')).is_file() for name in MODULES):
            self.skipTest('Generated native objects unavailable; set RECOMP_BUILD to a complete existing build')
        objects += [build / (name + '.o') for name in MODULES]
        compiler = shlex.split(os.environ.get('CC', 'xcrun clang' if sys.platform == 'darwin' else 'cc'))
        if not compiler or not shutil.which(compiler[0]):
            self.skipTest('Native compiler unavailable; set CC')
        parent = WORK / 'recomp-sqrt-tests'
        parent.mkdir(parents=True, exist_ok=True)
        output = Path(tempfile.mkdtemp(prefix='native-', dir=parent))
        executable = output / 'recomp-sqrt-fixture'
        fixture = PROJECT / 'tests/recomp_sqrt_fixture.c'
        headers = [PROJECT / 'recomp' / name for name in ('rc.h', 'rc_internal.h', 'rc_platform.h')]
        headers += [PROJECT / 'src' / name for name in ('original_methods_fl41.h', 'original_methods_fl41_x87.h')]
        inputs = [Path(__file__), fixture, ORIGINAL] + headers + objects
        pins = {str(p): sha(p) for p in inputs}
        command = compiler + ['-std=gnu11', '-O2', '-Wall', '-Wextra', '-Wno-unused-parameter',
                              '-I' + str(PROJECT / 'src'), '-I' + str(PROJECT / 'recomp'),
                              '-I' + str(build), str(fixture)]
        command += [str(p) for p in objects] + ['-lm', '-pthread', '-o', str(executable)]
        compiled = subprocess.run(command, capture_output=True, text=True, timeout=60)
        (output / 'build.log').write_text(compiled.stdout + compiled.stderr)
        receipt = {'inputs_sha256': pins, 'build_command': command, 'build_exit_code': compiled.returncode,
                   'fixture_executed': False, 'original_x86_executed': False, 'game_entry_executed': False}
        result = None
        if compiled.returncode == 0:
            receipt['native_sha256'] = sha(executable)
            result = subprocess.run([str(executable), str(ORIGINAL)], capture_output=True, text=True, timeout=15)
            (output / 'run.log').write_text(result.stdout + result.stderr)
            receipt.update(fixture_executed=True, fixture_exit_code=result.returncode)
        receipt['production_inputs_unchanged'] = all(sha(Path(p)) == digest for p, digest in pins.items())
        (output / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
        print('RECOMP_SQRT private_output=' + str(output))
        self.assertTrue(receipt['production_inputs_unchanged'], 'Inputs changed during fixture')
        self.assertEqual(compiled.returncode, 0, compiled.stdout + compiled.stderr)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn('RECOMP_SQRT cases=9 failures=0', result.stdout)


if __name__ == '__main__':
    unittest.main()
