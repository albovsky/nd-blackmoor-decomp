"""Hidden AppKit cursor-rectangle checks, never a displayed-window/mouse test.

Owner QA plan E authorizes this hidden-view fixture category. No game, original
assets, audio, real input, visible window or persistent preferences are used.
"""
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


class SoftwareCursorTests(unittest.TestCase):
    @unittest.skipUnless(sys.platform == 'darwin', 'requires hidden macOS AppKit views')
    def test_only_the_rendered_game_surface_uses_a_transparent_system_cursor(self):
        parent = Path(os.environ.get('BLACKMOOR_CURSOR_EVIDENCE', tempfile.gettempdir()))
        parent.mkdir(parents=True, exist_ok=True)
        out = Path(tempfile.mkdtemp(prefix='software-cursor-', dir=parent))
        fixture = HERE / 'macos_software_cursor_fixture.mm'
        inputs = [fixture, Path(__file__), PROJECT / 'src/macos_platform.mm',
                  PROJECT / 'src/macos_platform.h', PROJECT / 'src/macos_platform_background.h',
                  PROJECT / 'src/native_display_geometry.c', PROJECT / 'src/native_display_geometry.h']
        pins = {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs}
        cc = shlex.split(os.environ.get('CC', 'xcrun --sdk macosx clang'))
        cxx = shlex.split(os.environ.get('CXX', 'xcrun --sdk macosx clang++'))
        flags = shlex.split(os.environ.get('BLACKMOOR_CURSOR_CFLAGS', ''))
        commands = [cc + ['-std=c11', '-O1', '-g'] + flags + ['-c',
                    str(PROJECT / 'src/native_display_geometry.c'), '-o', str(out / 'geometry.o')],
                    cxx + ['-std=c++17', '-fobjc-arc', '-Wall', '-Wextra', '-O1', '-g',
                    '-Wl,-export_dynamic'] + flags + [str(fixture), str(out / 'geometry.o'),
                    '-framework', 'AppKit', '-framework', 'Foundation', '-framework', 'CoreGraphics',
                    '-o', str(out / 'cursor-fixture')]]
        receipt = {'commands': commands, 'inputs_sha256': pins,
                   'foreground_window': False, 'audio': False, 'os_input': False,
                   'persistent_preferences': False, 'render_scope': 'actual hidden view cursor registration'}
        try:
            for index, command in enumerate(commands):
                result = subprocess.run(command, capture_output=True, text=True, timeout=90)
                (out / ('build-' + str(index) + '.log')).write_text(result.stdout + result.stderr)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            receipt['native_sha256'] = hashlib.sha256((out / 'cursor-fixture').read_bytes()).hexdigest()
            result = subprocess.run([str(out / 'cursor-fixture')], capture_output=True, text=True, timeout=15)
            (out / 'run.log').write_text(result.stdout + result.stderr)
            receipt['exit'] = result.returncode
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('failures=0 activations=0 visible=0 key=0', result.stdout)
        finally:
            receipt['inputs_unchanged'] = all(hashlib.sha256(Path(p).read_bytes()).hexdigest() == h
                                            for p, h in pins.items())
            (out / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
            print('SOFTWARE_CURSOR private_output=' + str(out))


if __name__ == '__main__':
    unittest.main()
