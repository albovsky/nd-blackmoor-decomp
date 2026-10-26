"""NATIVE16 rich-text font switches: synthetic pixels and normal C subprocesses."""
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]


class NativeConversationFontTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = shutil.which('clang') or shutil.which('cc')
        if compiler is None:
            raise RuntimeError('C compiler required')
        cls.temp = tempfile.TemporaryDirectory(prefix='blackmoor-conversation-fonts-')
        cls.addClassCleanup(cls.temp.cleanup)
        cls.executable = Path(cls.temp.name) / 'native-conversation-fonts'
        core = Path(os.environ.get('BLACKMOOR_NATIVE_CONVERSATION_FONT_PROJECT', PROJECT)).resolve()
        command = [compiler, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2',
                   '-I' + str(core / 'src'), str(core / 'src/caption_layout.c'),
                   str(core / 'src/native_conversation_caption.c'),
                   str(PROJECT / 'tests/native_conversation_font_test.c'), '-o', str(cls.executable)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError('Conversation font test compilation failed:\n' + (result.stdout + result.stderr)[:4000])
        print('NATIVE_CONVERSATION_FONTS_BUILD executable_sha256=' +
              hashlib.sha256(cls.executable.read_bytes()).hexdigest() + ' core=' + str(core))

    def check_case(self, name):
        result = subprocess.run([str(self.executable), name], capture_output=True, text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout.strip(), 'PASS native_conversation_fonts ' + name)

    def test_absolute_fonts_both_surfaces_use_distinct_sheet_pixels_and_atoi(self):
        self.check_case('absolute')

    def test_empty_pending_newlines_flush_with_old_font_and_keep_half_spacing(self):
        self.check_case('newline')

    def test_same_font_reacquires_and_caller_sheet_reference_survives(self):
        self.check_case('same')

    def test_invalid_font_preflight_and_failed_new_acquisition_preserve_ownership(self):
        self.check_case('errors')


if __name__ == '__main__':
    unittest.main()
