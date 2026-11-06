"""Guest ShowCursor count and frontend synchronization; no actual game or UI."""
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent


class CursorVisibilityTests(unittest.TestCase):
    def exercise(self, label, objective_cpp):
        parent = Path(os.environ.get('BLACKMOOR_CURSOR_EVIDENCE', tempfile.gettempdir()))
        parent.mkdir(parents=True, exist_ok=True)
        out = Path(tempfile.mkdtemp(prefix=label + '-', dir=parent))
        compiler = shlex.split(os.environ.get('CXX' if objective_cpp else 'CC',
                              'xcrun --sdk macosx clang++' if objective_cpp else
                              ('clang' if sys.platform == 'darwin' else 'cc')))
        fixture = HERE / ('recomp_cursor_tick_fixture.mm' if objective_cpp else 'recomp_cursor_visibility_fixture.c')
        dead_strip = '-Wl,-dead_strip' if sys.platform == 'darwin' else '-Wl,--gc-sections'
        command = compiler + ['-O1', '-g', '-ffunction-sections', '-fdata-sections',
                              '-I' + str(PROJECT / 'src'), '-I' + str(PROJECT / 'recomp')]
        command += shlex.split(os.environ.get('BLACKMOOR_CURSOR_CFLAGS', ''))
        if objective_cpp:
            command += ['-std=c++17', '-fobjc-arc', str(fixture),
                        str(PROJECT / 'recomp/macos_game_data.mm'), str(PROJECT / 'recomp/audio_capture.cpp'),
                        '-framework', 'AppKit', '-framework', 'Foundation', '-framework', 'AVFAudio']
        else:
            command += ['-std=gnu11', str(fixture), '-pthread', '-lm']
            if sys.platform == 'darwin':
                # Baseline has no query yet: allow only this weak import so its
                # absent predicate can fail assertions instead of the linker.
                command += ['-Wl,-U,_rc_system_cursor_visible']
        command += [dead_strip, '-o', str(out / 'fixture')]
        inputs = [Path(__file__), fixture, PROJECT / 'recomp/rc_platform.h',
                  PROJECT / 'recomp/rc_win32.c', PROJECT / 'recomp/macos_recomp.mm',
                  PROJECT / 'recomp/rc.h', PROJECT / 'recomp/rc_internal.h']
        pins = {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs}
        receipt = {'command': command, 'input_sha256': pins,
                   'scope': 'Finite adapter/tick execution; no guest, original assets, window, audio or preferences'}
        try:
            built = subprocess.run(command, capture_output=True, text=True, timeout=90)
            (out / 'build.log').write_text(built.stdout + built.stderr)
            self.assertEqual(built.returncode, 0, built.stdout + built.stderr)
            receipt['native_sha256'] = hashlib.sha256((out / 'fixture').read_bytes()).hexdigest()
            result = subprocess.run([str(out / 'fixture')], capture_output=True, text=True, timeout=15)
            (out / 'run.log').write_text(result.stdout + result.stderr)
            receipt['exit'] = result.returncode
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('failures=0', result.stdout)
        finally:
            receipt['inputs_unchanged'] = all(hashlib.sha256(Path(p).read_bytes()).hexdigest() == h
                                            for p, h in pins.items())
            (out / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
            print('CURSOR_VISIBILITY private_output=' + str(out))

    def test_show_cursor_return_values_and_visible_predicate(self):
        self.exercise('counter', False)

    @unittest.skipUnless(sys.platform == 'darwin', 'macOS frontend requires AppKit')
    def test_frontend_tick_preserves_native_cursor_requests(self):
        self.exercise('frontend-tick', True)


if __name__ == '__main__':
    unittest.main()
