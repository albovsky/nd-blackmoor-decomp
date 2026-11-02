"""Device-free exit classification; no guest execution or fault injection."""
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class DiagnosticResultTests(unittest.TestCase):
    def test_only_normal_return_requested_stop_or_zero_exit_succeed(self):
        compiler = shutil.which('clang') or shutil.which('cc')
        self.assertIsNotNone(compiler, 'C compiler required')
        include = Path(__file__).resolve().parents[1] / 'recomp'
        source = r'''
#include "diagnostic_result.h"
#include <stdio.h>
int main(void) {
    struct { int result; const char *reason; int expected; } cases[] = {
        {0, "returned from entry point", 1}, {0, NULL, 1},
        {1, "stop requested", 1}, {1, "stop requested <50e7e5", 1},
        {1, "ExitProcess(0)", 1}, {1, "ExitProcess(0) <50e7e5", 1},
        {1, NULL, 0}, {1, "", 0}, {1, "stop request", 0},
        {1, "stop requested-error", 0}, {1, "ExitProcess(1)", 0},
        {1, "ExitProcess(0)extra", 0}, {1, "import budget exhausted", 0},
        {1, "call to 0x123456: not lifted and no host port", 0}
    };
    for (unsigned i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        if (rc_diagnostic_guest_succeeded(cases[i].result, cases[i].reason) != cases[i].expected) {
            fprintf(stderr, "classification case %u failed\n", i);
            return 1;
        }
    }
    return 0;
}
'''
        with tempfile.TemporaryDirectory(prefix='blackmoor-diagnostic-result-') as directory:
            root = Path(directory)
            cfile, executable = root / 'fixture.c', root / 'fixture'
            cfile.write_text(source)
            built = subprocess.run([compiler, '-std=c11', '-Wall', '-Wextra', '-Werror',
                                    '-I' + str(include), str(cfile), '-o', str(executable)],
                                   capture_output=True, text=True, timeout=30)
            self.assertEqual(built.returncode, 0, built.stdout + built.stderr)
            run = subprocess.run([str(executable)], capture_output=True, text=True, timeout=5)
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)


if __name__ == '__main__':
    unittest.main()
