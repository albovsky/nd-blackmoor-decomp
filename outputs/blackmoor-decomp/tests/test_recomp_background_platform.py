"""Opt-in background AppKit acceptance, never enabled implicitly.

Run only after root applies/reviews the API patch and the owner authorizes an
unlocked desktop: BLACKMOOR_BACKGROUND_UI_TEST=1 python3 this-file.py -v
This uses synthetic RGBA and direct hidden-view NSEvents in a separate process
for each fit/stretch mode. It uses no game, owner assets, audio or OS input and
makes no physical-input or displayed-pixel claim. Display preferences are only
set in the fixture process's volatile NSArgumentDomain.
Pure geometry remains covered separately by test_native_display_geometry.py.
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


HERE = Path(__file__).resolve().parent
START = Path(os.environ.get('BLACKMOOR_REPOSITORY', Path.cwd())).resolve()
ROOT = next((p for p in (START, *START.parents, HERE, *HERE.parents)
             if (p / 'outputs/blackmoor-decomp/src/macos_platform.mm').is_file()), None)
PROJECT = ROOT / 'outputs/blackmoor-decomp' if ROOT else None
WORK = Path(os.environ.get('BLACKMOOR_ORIGINAL_WORK', ROOT / 'work' if ROOT else HERE))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class BackgroundPlatformTests(unittest.TestCase):
    def test_background_pointer_modes_stay_hidden_through_four_ticks(self):
        if os.environ.get('BLACKMOOR_BACKGROUND_UI_TEST') != '1':
            self.skipTest('Opt in only with unlocked-desktop authorization: BLACKMOOR_BACKGROUND_UI_TEST=1')
        if sys.platform != 'darwin':
            self.skipTest('Actual background AppKit platform requires macOS')
        if PROJECT is None:
            self.skipTest('Repository platform sources unavailable')
        background_header = PROJECT / 'src/macos_platform_background.h'
        if not background_header.is_file():
            self.skipTest('Background API patch is not applied')
        cc = shlex.split(os.environ.get('CC', 'xcrun --sdk macosx clang'))
        cxx = shlex.split(os.environ.get('CXX', 'xcrun --sdk macosx clang++'))
        if not cc or not cxx or not shutil.which(cc[0]) or not shutil.which(cxx[0]):
            self.skipTest('macOS C and Objective-C++ compilers are required')
        fixture = HERE / 'recomp_background_platform_fixture.mm'
        platform = PROJECT / 'src/macos_platform.mm'
        geometry = PROJECT / 'src/native_display_geometry.c'
        headers = [PROJECT / 'src/macos_platform.h', background_header,
                   PROJECT / 'src/native_display_geometry.h']
        inputs = [Path(__file__), fixture, platform, geometry] + headers
        pins = {str(p): sha(p) for p in inputs}
        parent = WORK / 'background-platform-test-results'
        parent.mkdir(parents=True, exist_ok=True)
        output = Path(tempfile.mkdtemp(prefix='native-', dir=parent))
        geometry_object = output / 'geometry.o'
        executable = output / 'background-platform-test'
        commands = [
            cc + ['-std=c11', '-O2', '-Wall', '-Wextra', '-c', str(geometry), '-o', str(geometry_object)],
            cxx + ['-std=c++17', '-fobjc-arc', '-fexceptions', '-fobjc-exceptions',
                   '-O2', '-Wall', '-Wextra', '-I' + str(PROJECT / 'src'),
                   str(fixture), str(platform), str(geometry_object),
                   '-framework', 'AppKit', '-framework', 'Foundation',
                   '-framework', 'CoreGraphics', '-o', str(executable)],
        ]
        receipt = {'inputs_sha256': pins, 'build_commands': commands,
                   'build_exit_codes': [], 'fixture_launch_attempted': False, 'fixture_executed': False,
                   'foreground_opener_called': False, 'game_executed': False,
                   'audio_executed': False, 'os_input_injected': False,
                   'input_delivery': 'direct hidden content-view methods',
                   'physical_input_verified': False, 'display_modes': ['fit', 'stretch'],
                   'fixture_runs': [],
                   'opt_in': 'BLACKMOOR_BACKGROUND_UI_TEST=1'}
        try:
            for index, command in enumerate(commands):
                built = subprocess.run(command, capture_output=True, text=True, timeout=60)
                (output / ('build-' + str(index) + '.log')).write_text(built.stdout + built.stderr)
                receipt['build_exit_codes'].append(built.returncode)
                self.assertEqual(built.returncode, 0, built.stdout + built.stderr)
            receipt['native_sha256'] = sha(executable)
            for mode in ('fit', 'stretch'):
                with self.subTest(display_mode=mode):
                    command = [str(executable), '--display', mode]
                    run = {'display_mode': mode, 'command': command,
                           'launch_attempted': True, 'executed': False}
                    receipt['fixture_runs'].append(run)
                    receipt['fixture_launch_attempted'] = True
                    try:
                        result = subprocess.run(command, capture_output=True, text=True, timeout=10)
                    except subprocess.TimeoutExpired as timeout:
                        receipt['fixture_executed'] = run['executed'] = True
                        run['timeout_seconds'] = timeout.timeout
                        (output / ('run-' + mode + '.log')).write_text(str(timeout))
                        self.fail('Background ' + mode + ' fixture timed out; see ' + str(output))
                    receipt['fixture_executed'] = run['executed'] = True
                    run['exit_code'] = result.returncode
                    (output / ('run-' + mode + '.log')).write_text(result.stdout + result.stderr)
                    self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                    self.assertIn('BACKGROUND_PLATFORM ticks=4 presentations=5 activations=0 failures=0 closed=1',
                                  result.stdout)
                    self.assertIn('BACKGROUND_POINTER mode=' + mode + ' content=960x480 events=10 checked=10',
                                  result.stdout)
        except subprocess.TimeoutExpired as timeout:
            receipt['build_timeout_seconds'] = timeout.timeout
            (output / 'timeout.log').write_text(str(timeout))
            self.fail('Background platform fixture build timed out; see ' + str(output))
        finally:
            receipt['inputs_unchanged'] = all(sha(Path(p)) == digest for p, digest in pins.items())
            (output / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
            print('BACKGROUND_PLATFORM private_output=' + str(output))
        self.assertTrue(receipt['inputs_unchanged'], 'Platform inputs changed during acceptance')


if __name__ == '__main__':
    unittest.main()
