"""FL-21 (batch a): the ports of src/original_methods_fl21a.c under AddressSanitizer and UndefinedBehaviorSanitizer.

Two programs are built with -fsanitize=address,undefined (no recovery): tests/fl21a_direct_test.c (every direct case) and
tests/fl21a_sanitize_fuzz.c (3000 rounds of bounded malformed inputs for each of the five ports, buffers of exact size). Skipped where the
compiler has no sanitizer runtime.
"""
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import test_fl21a_direct as direct

PROJECT = direct.PROJECT
SANITIZE = ['-fsanitize=address,undefined', '-fno-sanitize-recover=all', '-fno-omit-frame-pointer']


class Fl21aSanitize(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.directory.cleanup)

    def build(self, name, test_c):
        out = Path(self.directory.name) / name
        built = direct.build(out, test_c=test_c, extra=SANITIZE)
        if built.returncode != 0 and not os.environ.get('CC') and shutil.which('gcc'):   # (the clang found may lack its sanitizer runtime)
            os.environ['CC'] = shutil.which('gcc')
            try:
                built = direct.build(out, test_c=test_c, extra=SANITIZE)
            finally:
                del os.environ['CC']
        if built.returncode != 0:
            if 'libasan' in built.stderr or 'libclang_rt' in built.stderr or 'libubsan' in built.stderr:
                self.skipTest('no sanitizer runtime: ' + built.stderr[:200])
            self.fail(built.stderr)
        return out

    def test_direct_cases_are_clean(self):
        out = self.build('direct_san', direct.TEST_C)
        done = subprocess.run([str(out)], capture_output=True, text=True, timeout=300)
        self.assertEqual(done.returncode, 0, done.stdout + done.stderr)
        self.assertEqual(done.stdout.count('PASS'), len(direct.EXPECTED))

    def test_bounded_malformed_inputs_are_clean(self):
        out = self.build('fuzz_san', PROJECT / 'tests/fl21a_sanitize_fuzz.c')
        done = subprocess.run([str(out)], capture_output=True, text=True, timeout=600)
        self.assertEqual(done.returncode, 0, done.stdout + done.stderr)
        self.assertEqual(done.stdout.strip(), 'OK 3000')


if __name__ == '__main__':
    unittest.main()
